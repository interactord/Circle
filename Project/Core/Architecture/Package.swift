// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Architecture",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "Architecture",
      targets: ["Architecture"]),
  ],
  dependencies: [
    .package(path: "../DesignSystem"),
    .package(path: "../Domain"),
    .package(path: "../Platform"),
    .package(
      url: "https://github.com/interactord/LinkNavigator",
      branch: "param-refactor"),
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .upToNextMajor(from: "1.2.0")),
  ],
  targets: [
    .target(
      name: "Architecture",
      dependencies: [
        "DesignSystem",
        "Domain",
        "Platform",
        "LinkNavigator",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]),
    .testTarget(
      name: "ArchitectureTests",
      dependencies: ["Architecture"]),
  ])
