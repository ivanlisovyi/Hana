// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Basics",
  platforms: [
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v5),
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "Basics",
      targets: ["Basics"]
    ),
  ],
  targets: [
    .target(
      name: "Basics",
      dependencies: []
    ),
    .testTarget(
      name: "BasicsTests",
      dependencies: ["Basics"]
    ),
  ]
)
