// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "KindlyArchive",
    products: [
        .library(name: "KindlyArchive", targets: ["KindlyArchive"]),
        .executable(name: "kiar", targets: ["kiar"])
    ],
    dependencies: [
        .package(url: "https://github.com/omochi/FilePath.git", from: "1.0.1"),
    ],
    targets: [
        .target(name: "KindlyArchive", dependencies: ["FilePathFramework"]),
        .target(name: "kiar", dependencies: ["KindlyArchive"]),
        .testTarget(name: "KindlyArchiveTests", dependencies: ["KindlyArchive"]),
    ]
)
