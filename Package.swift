// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SegmentCastle",
    platforms: [
        .iOS("13.0"),
        .tvOS("11.0"),
        .watchOS("7.1")
    ],
    products: [
        .library(
            name: "SegmentCastle",
            targets: ["SegmentCastle"]),
    ],
    dependencies: [
        .package(
            name: "Segment",
            url: "https://github.com/segmentio/analytics-swift.git",
            from: "1.1.2"
        ),
        .package(
            name: "Castle",
            url: "https://github.com/castle/castle-ios",
            from: "3.0.7"
        )
    ],
    targets: [
        .target(
            name: "SegmentCastle",
            dependencies: ["Segment", "Castle"]),
    ]
)

