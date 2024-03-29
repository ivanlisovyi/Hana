// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Posts",
  platforms: [
    .iOS(.v14),
  ],
  products: [
    .library(
      name: "Posts",
      targets: ["Posts"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.9.0")),
    .package(path: "../Packages/UI"),
    .package(path: "../Packages/Common"),
    .package(path: "../Packages/Kaori"),
    .package(path: "../Features/Post")
  ],
  targets: [
    .target(
      name: "Posts",
      dependencies: [
        "UI",
        "Common",
        "Kaori",
        "Post",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      resources: [
        .process("JsonMocks")
      ]
    ),
    .testTarget(
      name: "PostsTests",
      dependencies: ["Posts"]
    ),
  ]
)
