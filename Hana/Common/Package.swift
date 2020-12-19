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
    ),
  ],
  targets: [
    .target(
      name: "Common",
      dependencies: []
    ),
    .testTarget(
      name: "CommonTests",
      dependencies: ["Common"]
    ),
  ]
)
