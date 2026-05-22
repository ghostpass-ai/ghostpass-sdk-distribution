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
          checksum: "03b9bfb13670453acf35ea493564985bea2a44d90a1ade2648362a35ed336f3a"
      )
  ]
)
