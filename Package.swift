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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.3/GoPassSDK.xcframework.zip",
          checksum: "e9d0cfd126448e931ad100e2dbee216f0fb83a59fd00a919a4af88c3184876c9"
      )
  ]
)
