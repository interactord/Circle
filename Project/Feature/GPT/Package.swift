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
    .package(
      url: "https://github.com/apple/swift-markdown",
      branch: "main"),
    .package(
      url: "https://github.com/raspu/Highlightr",
      .upToNextMajor(from: "2.1.2")),
  ],
  targets: [
    .target(
      name: "GPT",
      dependencies: [
        "Architecture",
        .product(name: "Markdown", package: "swift-markdown"),
        "Highlightr",
      ]),
    .testTarget(
      name: "GPTTests",
      dependencies: ["GPT"]),
  ])
