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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.1.1/GoPassSDK.xcframework.zip",
          checksum: "0f8cb378988d5ec963fc6a1e310de98ae13be3227091f865ed9ebb265571a1ae"
      )
  ]
)
