// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "MathCat",
    products: [
        .executable(
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
        .executableTarget(
            name: "MathCat",
            dependencies: ["CMathCat"],
            sources: ["Main.swift"],
            cSettings: [
                .headerSearchPath("../CMathCat/Include"),
            ],
            linkerSettings: [
                .unsafeFlags(["-LSources/Lib"]),
                .linkedLibrary("libmathcat_c")
            ]
        ),
    ]
)