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
            ],
            linkerSettings: [
                .linkedLibrary("libmathcat_c"), // ⚠️ Replace "system-math-lib" with the actual library name (without lib prefix and extension)
                .unsafeFlags(["-L/usr/local/lib"]) // Add /usr/local/lib to linker search paths
            ]
        ),
        .target(
            name: "MathCat",
            dependencies: ["CMathCat"],
            sources: ["MathCat.swift"] // ⚠️ VERIFY: Swift wrapper code location
        ),
    ]
)