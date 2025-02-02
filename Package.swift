// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "OrientationKit",
    platforms: [
        .iOS(.v13), .macCatalyst(.v14), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "OrientationKit",
            targets: ["OrientationKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "OrientationKit",
            dependencies: []),
        .testTarget(
            name: "OrientationKitTests",
            dependencies: ["OrientationKit"]),
    ]
)
