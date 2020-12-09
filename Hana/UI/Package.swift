// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "UI",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "ViewModifiers",
      targets: ["ViewModifiers"]
    ),
    .library(
      name: "Extensions",
      targets: ["Extensions"]
    )
  ],
  targets: [
    .target(
      name: "ViewModifiers"
    ),
    .target(
      name: "Extensions"
    )
  ]
)
