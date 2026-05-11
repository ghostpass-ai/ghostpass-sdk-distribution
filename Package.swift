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
          checksum: "1450c83b6272b23b8cbd41956e9d082fde3e71f9b6583e6ca589b273f8780a91"
      )
  ]
)
