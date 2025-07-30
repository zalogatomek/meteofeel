// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MeteoFeelUtilities",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "MeteoFeelUtilities",
            targets: ["MeteoFeelUtilities"]
        ),
    ],
    targets: [
        .target(
            name: "MeteoFeelUtilities",
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("MemberImportVisibility"),
                .enableUpcomingFeature("InternalImportsByDefault")
            ]
        ),
        .testTarget(
            name: "MeteoFeelUtilitiesTests",
            dependencies: ["MeteoFeelUtilities"]
        ),
    ]
)
