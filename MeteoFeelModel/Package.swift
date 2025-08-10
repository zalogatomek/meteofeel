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
    dependencies: [
        .package(path: "../MeteoFeelUtilities")
    ],
    targets: [
        .target(
            name: "MeteoFeelModel",
            dependencies: ["MeteoFeelUtilities"],
            resources: [
                .process("Forecast/Infrastructure/Model/health_patterns.json")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("MemberImportVisibility"),
                .enableUpcomingFeature("InternalImportsByDefault")
            ]
        ),
        .testTarget(
            name: "MeteoFeelModelTests",
            dependencies: ["MeteoFeelModel", .product(name: "MeteoFeelTestUtilities", package: "MeteoFeelUtilities")]
        ),
    ]
)
