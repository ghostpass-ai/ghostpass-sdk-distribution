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
            url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.1.2/GoPassSDK.xcframework.zip",
            checksum: "4b5485c641bc3fcf27b261a2ccfe87a3d09df1d9c44c0904424311102594570a"
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
