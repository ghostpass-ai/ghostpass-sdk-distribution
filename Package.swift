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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.1/GoPassSDK.xcframework.zip",
          checksum: "f37ba4b1695315380b5aa7579cc53296f50b403dc0413c4ccb2a6e2ac70a52e4"
      )
  ]
)
