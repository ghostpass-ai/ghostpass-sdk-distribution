// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GoPassSDK",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "GoPassSDK", targets: ["GoPassSDK"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            "10.0.0"..<"13.0.0"
        )
    ],
    targets: [
        .binaryTarget(
            name: "GoPassSDKBinary",
            url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.0.0/GoPassSDK.xcframework.zip",
            checksum: "ed65e311a3b2a4d969211179d9eb518c087d1247b3cecc5b0b5fd81644ec3aee"
        ),
        .target(
            name: "GoPassSDK",
            dependencies: [
                "GoPassSDKBinary",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
            ]
        )
    ]
)
