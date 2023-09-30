// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Platform",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "Platform",
      targets: ["Platform"]),
  ],
  targets: [
    .target(
      name: "Platform"),
    .testTarget(
      name: "PlatformTests",
      dependencies: ["Platform"]),
  ])
