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
    .package(url: "git@github.com:ivanlisovyi/Ning.git", .branch("master"))
  ],
  targets: [
    .target(
      name: "Kaori",
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
