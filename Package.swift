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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.2/GoPassSDK.xcframework.zip",
          checksum: "0139b020831c29d8bc8f563310b05ce7f2ad751c84f1c3f607dcdb76135efd78"
      )
  ]
)
