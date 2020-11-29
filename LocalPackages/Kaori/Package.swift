// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Kaori",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "Kaori",
      targets: ["Kaori"]),
  ],
  dependencies: [
    .package(path: "../Networking")
  ],
  targets: [
    .target(
      name: "Kaori",
      dependencies: [
        "Networking"
      ]
    ),
    .testTarget(
      name: "KaoriTests",
      dependencies: ["Kaori"]),
  ]
)
