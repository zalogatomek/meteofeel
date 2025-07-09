// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MeteoFeelModel",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "MeteoFeelModel",
            targets: ["MeteoFeelModel"]
        ),
    ],
    targets: [
        .target(
            name: "MeteoFeelModel",
            path: "Sources/MeteoFeelModel",
            resources: [
                .process("Forecast/Infrastructure/Model/health_patterns.json")
            ]
        ),
        .testTarget(
            name: "MeteoFeelModelTests",
            dependencies: ["MeteoFeelModel"],
            path: "Tests/MeteoFeelModelTests"
        ),
    ]
)
