// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppUpdater",
    products: [
        .library(
            name: "AppUpdater",
            targets: ["AppUpdater"]
        )
    ],
    targets: [
        .target(
            name: "AppUpdater",
            dependencies: []
        ),
        .testTarget(
            name: "AppUpdaterTests",
            dependencies: ["AppUpdater"]
        )
    ]
)
