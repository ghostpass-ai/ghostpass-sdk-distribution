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
            url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.0/GoPassSDK.xcframework.zip",
            // url: "https://api.github.com/repos/ghostpass-ai/ghostpass-sdk-distribution/releases/assets/366435406.zip",
            checksum: "836c7e41d70aa71ad8f14897a3845c153cc431f4483799613c71320c929cc73f"
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
