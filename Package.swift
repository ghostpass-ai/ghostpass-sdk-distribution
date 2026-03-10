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
            url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.1.0/GoPassSDK.xcframework.zip",
            checksum: "e9b63c7094b7c97a2fd739989f6afb39353a9936666de7c7e2b175587740afce"
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
