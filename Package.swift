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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.1.2/GoPassSDK.xcframework.zip",
          checksum: "b4b466c597dc6ba8916555418bf08a60b140b7af67a6e9a0fcb56b5b17444f16"
      )
  ]
)
