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
          checksum: "5324a14d99165e2030a803f83860c60db0ac6f32b25f7f70119cbacedcd16240"
      )
  ]
)
