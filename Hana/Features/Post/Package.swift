// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Post",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "Post",
      targets: ["Post"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.9.0")),
    .package(path: "../Packages/Common"),
    .package(path: "../Packages/UI"),
    .package(path: "../Packages/Kaori")
  ],
  targets: [
    .target(
      name: "Post",
      dependencies: [
        "Common",
        "UI",
        "Kaori",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      resources: [
        .process("JsonMocks")
      ]
    ),
    .testTarget(
      name: "PostTests",
      dependencies: ["Post"]
    ),
  ]
)
