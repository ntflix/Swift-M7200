// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swift-M7200",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Swift-M7200",
            targets: ["Swift-M7200"]
        ),
        .executable(name: "Swift-M7200-Demo", targets: ["Swift-M7200-Demo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.6.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Swift-M7200",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .target(
            name: "Swift-M7200-Demo",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .target(name: "Swift-M7200"),
            ]
        ),
        .testTarget(
            name: "Swift-M7200Tests",
            dependencies: ["Swift-M7200"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
