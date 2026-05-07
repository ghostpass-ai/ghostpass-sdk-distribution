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
          checksum: "bffdc2505f7fd9a70b75faff27504bac54088d4af7e09ce4c2fbd1388cb9441e"
      )
  ]
)
