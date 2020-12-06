// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Kaori",
  platforms: [
    .iOS(.v14),
    .tvOS(.v14),
    .watchOS(.v5),
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "Kaori",
      targets: ["Kaori"]
    ),
    .library(
      name: "KaoriLive",
      targets: ["KaoriLive"]
    )
  ],
  dependencies: [
    .package(url: "git@github.com:ivanlisovyi/Ning.git", .branch("master")),
  ],
  targets: [
    .target(
      name: "Kaori"
    ),
    .target(
      name: "KaoriLive",
      dependencies: [
        "Ning"
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
