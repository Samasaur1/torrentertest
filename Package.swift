// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "torrentertest",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Samasaur1/TorrentKit", .revision("4f4d13d03c171199a101b873d80342386562e7d8")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "torrentertest",
            dependencies: ["TorrentKit"]),
        .testTarget(
            name: "torrentertestTests",
            dependencies: ["torrentertest"]),
    ]
)
