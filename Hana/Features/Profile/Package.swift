// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Profile",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "Profile",
      targets: ["Profile"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.9.0")),
    .package(path: "../Packages/Kaori"),
    .package(path: "../Packages/UI"),
    .package(path: "../Login")
  ],
  targets: [
    .target(
      name: "Profile",
      dependencies: [
        "Kaori",
        "Login",
        "UI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      resources: [
        .process("JsonMocks")
      ]
    ),
    .testTarget(
      name: "ProfileTests",
      dependencies: ["Profile"]
    ),
  ]
)
