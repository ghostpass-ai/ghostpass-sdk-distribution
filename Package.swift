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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.1.6/GoPassSDK.xcframework.zip",
          checksum: "f4039bc91f3d0f0c3cded371a73526b49151420461194c61fa9a160a5c022365"
      )
  ]
)
