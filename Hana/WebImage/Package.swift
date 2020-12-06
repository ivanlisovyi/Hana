// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "WebImage",
  platforms: [
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v5),
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "WebImage",
      targets: ["WebImage"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/kean/FetchImage", .upToNextMajor(from: "0.2.1"))
  ],
  targets: [
    .target(
      name: "WebImage",
      dependencies: [
        "FetchImage"
      ]
    )
  ]
)
