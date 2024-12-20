// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AccidentsViewer",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/duckdb/duckdb-swift.git", from: "1.1.0")
    ],
    targets: [
        .executableTarget(
            name: "AccidentsViewer",
            dependencies: [
                .product(name: "DuckDB", package: "duckdb-swift")
            ],
            path: "goodKnight"
        )
    ]
)
