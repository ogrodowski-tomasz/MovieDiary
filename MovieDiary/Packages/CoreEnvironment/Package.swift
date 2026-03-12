// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreEnvironment",
    platforms: [.iOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoreEnvironment",
            targets: ["CoreEnvironment"]
        ),
    ],
    dependencies: [
        .package(name: "CoreNetwork", path: "../CoreNetwork"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoreEnvironment",
            dependencies: [
                .product(name: "CoreNetwork", package: "CoreNetwork"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .defaultIsolation(MainActor.self) // DEBUG: Should it be MainActor?
            ]
        ),
        .testTarget(
            name: "CoreEnvironmentTests",
            dependencies: ["CoreEnvironment"]
        ),
    ]
)
