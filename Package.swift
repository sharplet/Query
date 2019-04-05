// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Query",
  products: [
    .library(name: "Query", targets: ["Query"]),
  ],
  targets: [
    .target(name: "Query"),
    .testTarget(name: "QueryTests", dependencies: ["Query"]),
  ]
)
