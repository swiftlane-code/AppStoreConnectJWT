// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppStoreConnectJWT",
	platforms: [.macOS(.v10_13)],
    products: [
        .library(
            name: "AppStoreConnectJWT",
            targets: ["AppStoreConnectJWT"]
		),
    ],
    dependencies: [
		.package(url: "https://github.com/Kitura/BlueECC.git", from: "1.1.0"),
    ],
    targets: [
		.target(
			name: "ES256SwiftJWT",
			dependencies: ["CryptorECC"]
		),
		.testTarget(
			name: "ES256SwiftJWTTests",
			dependencies: ["ES256SwiftJWT"]
		),
		
        .target(
            name: "AppStoreConnectJWT",
            dependencies: ["CryptorECC", "ES256SwiftJWT"]
		),
        .testTarget(
            name: "AppStoreConnectJWTTests",
            dependencies: ["AppStoreConnectJWT", "ES256SwiftJWT"]
		),
    ]
)
