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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.8/GoPassSDK.xcframework.zip",
          checksum: "7feef2dbcd4761331499201d553b8b0b092372fdef19b6f44ae0cf5c688f1ae7"
      )
  ]
)
