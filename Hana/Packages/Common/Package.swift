// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Common",
  platforms: [
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v5),
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "Common",
      targets: ["Common"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", .upToNextMajor(from: "4.2.1")),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.9.0"))
  ],
  targets: [
    .target(
      name: "Common",
      dependencies: [
        "Keychain"
      ]
    ),
    .target(
      name: "Keychain",
      dependencies: [
        "KeychainAccess",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "CommonTests",
      dependencies: ["Common"]
    ),
  ]
)
