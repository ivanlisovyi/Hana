// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Login",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "Login",
      targets: ["Login"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.9.0")),
    .package(path: "../Packages/Kaori"),
    .package(path: "../Packages/UI")
  ],
  targets: [
    .target(
      name: "Login",
      dependencies: [
        "Kaori",
        "UI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      resources: [
        .process("JsonMocks")
      ]
    ),
    .testTarget(
      name: "LoginTests",
      dependencies: ["Login"]
    ),
  ]
)
