// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "GPT",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "GPT",
      targets: ["GPT"]),
  ],
  dependencies: [
    .package(path: "../../Core/Architecture"),
  ],
  targets: [
    .target(
      name: "GPT",
      dependencies: [
        "Architecture",
      ]),
    .testTarget(
      name: "GPTTests",
      dependencies: ["GPT"]),
  ])
