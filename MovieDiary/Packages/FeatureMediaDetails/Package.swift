// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureMediaDetails",
    platforms: [.iOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FeatureMediaDetails",
            targets: ["FeatureMediaDetails"]
        ),
        
    ],
    dependencies: [
        .package(name: "CoreDesign", path: "../CoreDesign"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FeatureMediaDetails",
            dependencies: [
                .product(name: "CoreDesign", package: "CoreDesign")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self),
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "FeatureMediaDetailsTests",
            dependencies: ["FeatureMediaDetails"]
        ),
    ]
)
