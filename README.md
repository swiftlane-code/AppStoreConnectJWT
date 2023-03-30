# AppStoreConnectJWT

An implementation of [JSON Web Tokens](https://tools.ietf.org/html/rfc7519) generation 
for [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi).

Based on [SwiftJWT](https://github.com/Kitura/Swift-JWT). 
**SwiftJWT** package was stripped down to keep only code and dependencies required
to generate JWT tokens for **App Store Connect API**.

Target `ES256SwiftJWT` is the stripped down vesion of **SwiftJWT**. 
It supports only ES256 (ecdsa) signature as it is the only one required by **App Store Connect API**.

Original **SwiftJWT's** dependencies:
* Kept: [BlueECC](https://github.com/Kitura/BlueECC.git)
* Removed: [BlueRSA](https://github.com/Kitura/BlueRSA.git)
* Removed: [BlueCryptor](https://github.com/Kitura/BlueCryptor.git)
* Removed: [LoggerAPI](https://github.com/Kitura/LoggerAPI.git)
* Removed: [KituraContracts](https://github.com/Kitura/KituraContracts.git)

# Versions

### 0.9.0

**SwiftJWT** stripped from [3.6.201](https://github.com/Kitura/Swift-JWT/releases/tag/3.6.201)
