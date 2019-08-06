// swift-tools-version:4.0
import PackageDescription

var package = Package(
    name: "KittenCore",
    products: [
        .library(name: "KittenCore", targets: ["KittenCore"])
    ],
    targets: [
        .target(name: "KittenCore")
    ]
)
