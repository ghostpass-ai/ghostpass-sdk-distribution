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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.5/GoPassSDK.xcframework.zip",
          checksum: "ffa25c08494c3e008b7528186013a55cba54285ed69939a97a5868c967c764f8"
      )
  ]
)
