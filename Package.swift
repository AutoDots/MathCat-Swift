// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MathCat",
    products: [
        .library(
            name: "MathCat",
            targets: ["MathCat"]
        ),
    ],
    targets: [
        .target(
            name: "CMathCat",
            sources: ["MathCat.c"],
            publicHeadersPath: "Include",
            cSettings: [
                .headerSearchPath("Include")
            ]
        ),
        .target(
            name: "MathCat",
            dependencies: ["CMathCat"],
            sources: ["."] // ⚠️ VERIFY: Is your Swift wrapper code directly in Sources/MathCat?
                           // If in a subdirectory (e.g., Sources/MathCat/Wrapper), change to: ["Wrapper"]
        ),
    ]
)