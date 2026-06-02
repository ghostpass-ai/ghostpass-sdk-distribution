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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.4/GoPassSDK.xcframework.zip",
          checksum: "be0b5e3134e41c545cd49aaa9d370bfdffd4657f9e92ca06a675e58d49d87172"
      )
  ]
)
