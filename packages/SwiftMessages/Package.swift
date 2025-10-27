// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftMessages",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "SwiftMessages", targets: ["SwiftMessages"]),
        .library(name: "SwiftMessages-Dynamic", type: .dynamic, targets: ["SwiftMessages"])
    ],
    targets: [
        .target(
            name: "SwiftMessages",
            path: "SwiftMessages",
            exclude: [
                "Info.plist",
            ],
            resources: [.process("Resources")]
        )
    ]
)
