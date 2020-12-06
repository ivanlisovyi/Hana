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
    .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", .upToNextMajor(from: "1.5.0")),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.9.0")),
    .package(path: "../Kaori")
  ],
  targets: [
    .target(
      name: "Posts",
      dependencies: [
        "Kaori",
        "SDWebImageSwiftUI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "PostsTests",
      dependencies: ["Posts"]
    ),
  ]
)
