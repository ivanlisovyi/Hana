// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Kaori",
  platforms: [
    .iOS(.v14),
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "Kaori",
      targets: ["Kaori"]),
  ],
  dependencies: [
    .package(url: "git@github.com:ivanlisovyi/Ning.git", .branch("master")),
    .package(url: "git@github.com:ivanlisovyi/Coil.git", .upToNextMajor(from: "1.0.0")),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.9.0"))
  ],
  targets: [
    .target(
      name: "Kaori",
      dependencies: [
        "Ning",
        "Coil",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "KaoriTests",
      dependencies: [
        "Kaori",
        .product(name: "NingTestingSupport", package: "Ning")
      ]
    ),
  ]
)
