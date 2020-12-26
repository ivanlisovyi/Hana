// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "UI",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "UI",
      targets: ["UI"]
    ),
    .library(
      name: "Components",
      targets: ["Components"]
    ),
    .library(
      name: "ViewModifiers",
      targets: ["ViewModifiers"]
    ),
    .library(
      name: "Extensions",
      targets: ["Extensions"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/kean/FetchImage", .upToNextMajor(from: "0.2.1"))
  ],
  targets: [
    .target(
      name: "UI",
      dependencies: [
        "Components",
        "ViewModifiers",
        "Extensions",
      ]
    ),
    .target(
      name: "ViewModifiers"
    ),
    .target(
      name: "Extensions"
    ),
    .target(
      name: "Components",
      dependencies: [
        "FetchImage"
      ]
    )
  ]
)
