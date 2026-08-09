// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Arti",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "Tor",
            targets: ["Tor"]
        ),
        .library(
            name: "arti",
            targets: ["arti"]
        ),
    ],
    dependencies: [
        .package(path: "../BitLogger"),
    ],
    targets: [
        // Main Swift target
        .target(
            name: "Tor",
            dependencies: [
                "arti",
                .product(name: "BitLogger", package: "BitLogger"),
            ],
            path: ".",
            exclude: ["Sources/C"],
            sources: [
                "Sources/TorManager.swift",
                "Sources/TorURLSession.swift",
                "Sources/TorNotifications.swift",
            ],
            cSettings: [
                .headerSearchPath("Sources/C/include"),
                .headerSearchPath("Frameworks/include"),
            ],
            linkerSettings: [
                .linkedLibrary("resolv"),
                .linkedLibrary("z"),
                .linkedLibrary("sqlite3"),
            ]
        ),
        // Binary framework containing the Rust static library
        .binaryTarget(
            name: "arti",
            path: "Frameworks/arti.xcframework"
        ),
    ]
)
