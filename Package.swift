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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.6/GoPassSDK.xcframework.zip",
          checksum: "24523766112d0c005e0a8f805a3b5d09f99852bee1070c8fce17431dd087fa82"
      )
  ]
)
