// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MySDK",
    products: [
        .library(
            name: "MySDK",
            targets: ["MySDK"]),
    ],
    targets: [
        .binaryTarget(name: "MySDK", path: "MySDK/archives/MySDK.xcframework"),
    ]
)
