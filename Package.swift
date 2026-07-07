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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.9/GoPassSDK.xcframework.zip",
          checksum: "9c88fdcce4c0600ee450c49a8c8f0e491e13886f9e18734d89e97d2fe1e28bf1"
      )
  ]
)
