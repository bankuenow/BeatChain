;; BeatChain: NFT-Based Music Streaming Rights Platform
;; A revolutionary music rights management system that enables:
;; - Artist track publishing with configurable streaming parameters
;; - Fan streaming pass purchases using STX tokens
;; - Peer-to-peer streaming rights trading marketplace
;; - Track removal with automatic royalty redistribution

(define-non-fungible-token streaming-rights-pass (string-ascii 100))

;; Contract Configuration
(define-constant platform-owner tx-sender)
(define-constant ERR-UNAUTHORIZED-ACCESS (err u300))
(define-constant ERR-TRACK-ALREADY-PUBLISHED (err u301))
(define-constant ERR-TRACK-NOT-AVAILABLE (err u302))
(define-constant ERR-INVALID-RIGHTS-HOLDER (err u303))
(define-constant ERR-PARAMETER-VALIDATION-ERROR (err u304))
(define-constant ERR-STREAMING-QUOTA-EXCEEDED (err u305))
(define-constant ERR-TRACK-ALREADY-REMOVED (err u306))
(define-constant ERR-PAYMENT-PROCESSING_ERROR (err u307))
(define-constant ERR-ACTIVE-STREAMING-RIGHTS (err u308))
(define-constant ERR-INVALID-TRADING-PARTNER (err u309))
(define-constant ERR-TRACK-NOT_REMOVED (err u310))

;; Input Validation Functions
(define-private (is-track-title-valid (track-title (string-ascii 100)))
  (and 
    (> (len track-title) u0) 
    (<= (len track-title) u100)
  )
)

(define-private (is-release-info-valid (release-info (string-ascii 50)))
  (and 
    (> (len release-info) u0) 
    (<= (len release-info) u50)
  )
)

(define-private (is-streaming-cost-valid (streaming-cost uint))
  (> streaming-cost u0)
)

(define-private (is-max-streams-valid (max-streams uint))
  (> max-streams u0)
)

;; Identity Validation
(define-private (is-trading-partner-valid (partner-address principal))
  (not (is-eq partner-address platform-owner))
)

;; Data Storage
(define-map published-tracks 
  {track-id: (string-ascii 100)} 
  {
    track-title: (string-ascii 100),
    release-info: (string-ascii 50),
    streaming-cost: uint,
    max-streams: uint,
    active-streams: uint,
    track-removed: bool
  }
)

;; Streaming Rights Registry
(define-map streaming-fans
  {track-id: (string-ascii 100), fan-address: principal} 
  bool
)

;; Public Query Functions
(define-read-only (get-rights-owner (track-id (string-ascii 100)))
  (nft-get-owner? streaming-rights-pass track-id)
)

(define-read-only (get-track-metadata (track-id (string-ascii 100)))
  (map-get? published-tracks {track-id: track-id})
)

;; Publish New Music Track
(define-public (publish-track 
  (track-id (string-ascii 100))
  (track-title (string-ascii 100))
  (release-info (string-ascii 50))
  (streaming-cost uint)
  (max-streams uint)
)
  (begin
    ;; Validate inputs
    (asserts! (is-track-title-valid track-title) ERR-PARAMETER-VALIDATION-ERROR)
    (asserts! (is-release-info-valid release-info) ERR-PARAMETER-VALIDATION-ERROR)
    (asserts! (is-streaming-cost-valid streaming-cost) ERR-PARAMETER-VALIDATION-ERROR)
    (asserts! (is-max-streams-valid max-streams) ERR-PARAMETER-VALIDATION-ERROR)
    
    ;; Ensure track hasn't been published before
    (asserts! (is-none (get-track-metadata track-id)) ERR-TRACK-ALREADY-PUBLISHED)
    
    ;; Initialize track data
    (map-set published-tracks 
      {track-id: track-id}
      {
        track-title: track-title,
        release-info: release-info,
        streaming-cost: streaming-cost,
        max-streams: max-streams,
        active-streams: u0,
        track-removed: false
      }
    )
    
    ;; Register track in the platform
    (nft-mint? streaming-rights-pass track-id platform-owner)
  )
)

;; Update Track Metadata
(define-public (update-track-metadata
  (track-id (string-ascii 100))
  (updated-title (string-ascii 100))
  (updated-release-info (string-ascii 50))
  (updated-cost uint)
)
  (let ((track-data (unwrap! (get-track-metadata track-id) ERR-TRACK-NOT-AVAILABLE)))
    (begin
      ;; Security check
      (asserts! (is-eq tx-sender platform-owner) ERR-UNAUTHORIZED-ACCESS)
      
      ;; Prevent updates after streams sold
      (asserts! (is-eq (get active-streams track-data) u0) ERR-ACTIVE-STREAMING-RIGHTS)
      
      ;; Validate new parameters
      (asserts! (is-track-title-valid updated-title) ERR-PARAMETER-VALIDATION-ERROR)
      (asserts! (is-release-info-valid updated-release-info) ERR-PARAMETER-VALIDATION-ERROR)
      (asserts! (is-streaming-cost-valid updated-cost) ERR-PARAMETER-VALIDATION-ERROR)
      
      ;; Update track information
      (map-set published-tracks 
        {track-id: track-id}
        (merge track-data {
          track-title: updated-title,
          release-info: updated-release-info,
          streaming-cost: updated-cost
        })
      )
      
      (ok true)
    )
  )
)

;; Purchase Streaming Rights
(define-public (buy-streaming-rights (track-id (string-ascii 100)))
  (let ((track-data (unwrap! (get-track-metadata track-id) ERR-TRACK-NOT-AVAILABLE)))
    (begin
      ;; Check track status
      (asserts! (not (get track-removed track-data)) ERR-TRACK-ALREADY-REMOVED)
      
      ;; Check streaming quota availability
      (asserts! 
        (< (get active-streams track-data) (get max-streams track-data)) 
        ERR-STREAMING-QUOTA-EXCEEDED
      )
      
      ;; Process payment
      (try! (stx-transfer? (get streaming-cost track-data) tx-sender platform-owner))
      
      ;; Update streaming counter
      (map-set published-tracks 
        {track-id: track-id}
        (merge track-data {active-streams: (+ (get active-streams track-data) u1)})
      )
      
      ;; Register fan
      (map-set streaming-fans
        {track-id: track-id, fan-address: tx-sender} 
        true
      )
      
      ;; Mint streaming rights to buyer
      (nft-mint? streaming-rights-pass track-id tx-sender)
    )
  )
)