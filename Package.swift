// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UsefulArchive",
    products: [
        .library(name: "UsefulArchive", targets: ["UsefulArchive"]),
        .executable(name: "uar", targets: ["uar"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "UsefulArchive", dependencies: []),
        .target(name: "uar", dependencies: ["UsefulArchive"]),
        .testTarget(name: "UsefulArchiveTests", dependencies: ["UsefulArchive"]),
    ]
)
