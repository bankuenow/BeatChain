# BeatChain 🎵

**Decentralized Music Streaming Rights Platform**

BeatChain revolutionizes the music industry by creating a blockchain-based ecosystem where artists can publish tracks, fans can purchase streaming rights as NFTs, and a decentralized marketplace enables peer-to-peer trading of music access rights. Built on Stacks blockchain with STX-powered transactions.

## ✨ Features

### For Artists
- **Track Publishing**: Publish music with custom streaming parameters
- **Royalty Management**: Automated STX payments for streaming rights
- **Streaming Quotas**: Control distribution with maximum stream limits
- **Content Control**: Remove tracks with automatic refund processing
- **Metadata Updates**: Modify track information before rights are sold

### For Music Fans
- **Streaming Rights Purchase**: Buy NFT-based streaming access with STX
- **Rights Trading**: Trade streaming rights in secondary marketplace
- **Royalty Refunds**: Automatic compensation for removed tracks
- **Exclusive Access**: Limited streaming rights create scarcity value
- **Blockchain Ownership**: Provable ownership of music streaming rights

### Platform Features
- **Decentralized Architecture**: No central music platform control
- **Smart Contracts**: Automated royalty distribution and rights management
- **NFT Integration**: Each streaming right is a unique blockchain asset
- **Transparent Operations**: All transactions recorded on Stacks blockchain
- **Secondary Market**: Built-in peer-to-peer trading functionality

## 🛠 Technical Architecture

### Smart Contract Overview
```
BeatChain Platform
├── NFT Token: streaming-rights-pass
├── Core Functions
│   ├── publish-track()
│   ├── buy-streaming-rights()
│   ├── trade-streaming-rights()
│   └── claim-royalty-refund()
├── Management Functions
│   ├── update-track-metadata()
│   └── remove-track()
└── Query Functions
    ├── get-rights-owner()
    └── get-track-metadata()
```

### Data Models

**Track Metadata:**
```clarity
{
  track-id: string-ascii 100,
  track-title: string-ascii 100,
  release-info: string-ascii 50,
  streaming-cost: uint,
  max-streams: uint,
  active-streams: uint,
  track-removed: bool
}
```

**Fan Registry:**
```clarity
{
  track-id: string-ascii 100,
  fan-address: principal
} -> bool
```

## 🚀 Getting Started

### Prerequisites
- Stacks wallet with STX tokens
- Clarinet for local development
- Basic understanding of blockchain transactions

### Quick Start

#### Publish Your First Track
```clarity
(contract-call? .beatchain publish-track 
  "my-awesome-song-2024"
  "My Awesome Song"
  "Album: Blockchain Beats 2024"
  u25000000  ;; 25 STX per streaming right
  u1000      ;; Maximum 1000 streaming rights
)
```

#### Buy Streaming Rights
```clarity
(contract-call? .beatchain buy-streaming-rights "my-awesome-song-2024")
```

#### Trade Your Rights
```clarity
(contract-call? .beatchain trade-streaming-rights 
  "my-awesome-song-2024"
  'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7
)
```

## 💡 Use Cases

### Independent Artists
- Direct fan monetization without intermediaries
- Control over streaming distribution and pricing
- Build exclusive fan communities through limited releases
- Transparent royalty tracking and payments

### Music Collectors
- Own rare streaming rights as digital assets
- Trade exclusive access to limited releases
- Build portfolios of streaming rights from favorite artists
- Participate in music investment opportunities

### Record Labels
- Distribute catalog tracks with blockchain verification
- Create tiered access levels for different fan segments
- Manage artist royalties through smart contracts
- Enable new revenue streams through rights trading

### Music Platforms
- Integrate with existing streaming services
- Verify legitimate streaming rights ownership
- Create premium tiers based on blockchain holdings
- Enable cross-platform rights recognition

## 🔐 Security & Economics

### Security Features
- **Owner Verification**: All operations validate proper ownership
- **Payment Security**: Atomic STX transfers with failure handling
- **Access Control**: Platform owner privileges for critical functions
- **Input Validation**: Comprehensive parameter checking
- **State Protection**: Prevents invalid state transitions

### Economic Model
- **Artist Revenue**: Direct STX payments for streaming rights sales
- **Fan Investment**: Streaming rights can appreciate in secondary market
- **Platform Sustainability**: Transaction fees support development
- **Scarcity Value**: Limited streaming quotas create natural scarcity
- **Royalty Protection**: Automatic refunds for removed content

## 📊 Error Handling

### Error Codes
- `ERR-UNAUTHORIZED-ACCESS (300)`: Invalid permission level
- `ERR-TRACK-ALREADY-PUBLISHED (301)`: Duplicate track ID
- `ERR-TRACK-NOT-AVAILABLE (302)`: Track doesn't exist
- `ERR-INVALID-RIGHTS-HOLDER (303)`: Not the rights owner
- `ERR-PARAMETER-VALIDATION-ERROR (304)`: Invalid input parameters
- `ERR-STREAMING-QUOTA-EXCEEDED (305)`: No more rights available
- `ERR-TRACK-ALREADY-REMOVED (306)`: Operation on removed track
- `ERR-PAYMENT-PROCESSING_ERROR (307)`: STX transfer failed
- `ERR-ACTIVE-STREAMING-RIGHTS (308)`: Cannot modify active track
- `ERR-INVALID-TRADING-PARTNER (309)`: Invalid trade recipient

## 🔄 Workflow Examples

### Artist Workflow
1. Publish track with streaming parameters
2. Fans purchase streaming rights with STX
3. Monitor streaming rights sales and royalties
4. Optionally remove track and trigger refunds

### Fan Workflow
1. Browse available tracks on platform
2. Purchase streaming rights with STX payment
3. Receive NFT representing streaming access
4. Trade rights in secondary marketplace or hold for exclusive access

## 🌐 Integration Possibilities

- **Streaming Platforms**: Verify blockchain-based access rights
- **Social Media**: Display owned streaming rights as status
- **DeFi Protocols**: Use streaming rights as collateral
- **Gaming**: Integrate music rights into virtual worlds
- **Metaverse**: Stream owned music in virtual spaces

## 🛠 Development

### Local Setup
```bash
git clone <repository>
cd beatchain
clarinet check
clarinet test
```

### Testing
Run comprehensive tests covering:
- Track publishing workflows
- Streaming rights purchase scenarios
- Trading and transfer operations
- Refund mechanisms
- Edge cases and error conditions

## 🤝 Contributing

We welcome contributions to BeatChain! Areas for improvement:
- Enhanced metadata support for tracks
- Integration with IPFS for music storage
- Advanced royalty distribution mechanisms
- Mobile SDK development
- Artist dashboard improvements

## 📄 License

MIT License - See LICENSE file for details.

---

**BeatChain** - Democratizing music streaming through blockchain innovation 🎶🚀