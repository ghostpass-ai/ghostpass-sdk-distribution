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
            url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.1.1/GoPassSDK.xcframework.zip",
            checksum: "bd0893718f3d2650543dada0226f38c077b2eda1e6b67b0520450d37f044de5b"
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
