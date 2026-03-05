// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GoPassSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "GoPassSDK", targets: ["GoPassSDK", "GoPassSDKFirebase"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            "10.0.0"..<"13.0.0"
        )
    ],
    targets: [
        .binaryTarget(
            name: "GoPassSDK",
            url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.0.0/GoPassSDK.xcframework.zip",
            checksum: "1779ffb6a8a29f4fb46a8cc28529966cbba268265b635ee55a72e83974005cde"
        ),
        .target(
            name: "GoPassSDKFirebase",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
            ],
            path: "Sources/GoPassSDK"
        )
    ]
)
