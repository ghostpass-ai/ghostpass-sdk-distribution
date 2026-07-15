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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.1.0/GoPassSDK.xcframework.zip",
          checksum: "9a7014c60d3f3ac6c18f37fa78a22c20f1a96dfc75e3c985f6582d13ad8c4410"
      )
  ]
)
