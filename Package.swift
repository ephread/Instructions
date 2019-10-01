// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Instructions",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(name: "Instructions", targets: ["Instructions"]),
    ],
    targets: [
        .target(name: "Instructions")
    ]
)
