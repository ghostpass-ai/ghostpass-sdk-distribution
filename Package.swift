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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.0/GoPassSDK.xcframework.zip",
          checksum: "e0975b245425c92244afe2da2b9b717a169c8124ca0958dc3b9d3ba3e717c76b"
      )
  ]
)
