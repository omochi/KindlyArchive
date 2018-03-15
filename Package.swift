// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KindlyArchive",
    products: [
        .library(name: "KindlyArchive", targets: ["KindlyArchive"]),
        .executable(name: "kiar", targets: ["kiar"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "KindlyArchive", dependencies: []),
        .target(name: "kiar", dependencies: ["KindlyArchive"]),
        .testTarget(name: "KindlyArchiveTests", dependencies: ["KindlyArchive"]),
    ]
)
