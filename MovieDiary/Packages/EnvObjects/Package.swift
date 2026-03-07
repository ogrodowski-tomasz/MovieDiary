// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnvObjects",
    platforms: [.iOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EnvObjects",
            targets: ["EnvObjects"]
        ),
    ],
    dependencies: [
        .package(name: "NetworkClient", path: "../NetworkClient"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EnvObjects",
            dependencies: [
                .product(name: "NetworkClient", package: "NetworkClient")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "EnvObjectsTests",
            dependencies: ["EnvObjects"]
        ),
    ]
)
