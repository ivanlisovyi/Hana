// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Networking",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "Networking",
      targets: ["Networking"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Networking",
      dependencies: []),
    .testTarget(
      name: "NetworkingTests",
      dependencies: ["Networking"]),
  ]
)
