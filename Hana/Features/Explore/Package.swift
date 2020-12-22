// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Explore",
  platforms: [
    .iOS(.v14),
  ],
  products: [
    .library(
      name: "Explore",
      targets: ["Explore"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.9.0")),
    .package(path: "../Packages/Kaori"),
    .package(path: "../Packages/WebImage"),
    .package(path: "../Packages/UI"),
    .package(path: "../Packages/Common"),
    .package(path: "../Profile")
  ],
  targets: [
    .target(
      name: "Explore",
      dependencies: [
        "Kaori",
        "WebImage",
        "Common",
        "Profile",
        .product(name: "ViewModifiers", package: "UI"),
        .product(name: "Extensions", package: "UI"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      resources: [
        .process("JsonMocks")
      ]
    ),
    .testTarget(
      name: "ExploreTests",
      dependencies: ["Explore"]
    ),
  ]
)
