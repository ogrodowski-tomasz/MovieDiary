// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkClient",
    platforms: [.iOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkClient",
            targets: ["NetworkClient"]
        ),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "Utils", path: "../Utils"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkClient",
            dependencies: [
                .product(name: "Models", package: "Models"),
                .product(name: "Utils", package: "Utils"),
            ],
            resources: [
                .process("MockData")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "NetworkClientTests",
            dependencies: ["NetworkClient"],
            resources: [
//                .process("MockData")
            ]
        ),
    ]
)
