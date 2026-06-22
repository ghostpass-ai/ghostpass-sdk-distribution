// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "GoPassSDK",
  platforms: [.iOS(.v15)],
  products: [
      .library(name: "GoPassSDK", targets: ["GoPassSDK"])
  ],
  targets: [
      .binaryTarget(
          name: "GoPassSDK",
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.7/GoPassSDK.xcframework.zip",
          checksum: "28cd78de2e96dc676ba8896a537d91ae6a100f15abfc2449186eb8b3cd7a2fc2"
      )
  ]
)
