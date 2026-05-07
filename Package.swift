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
          checksum: "970add1259ab46382791a6e4ed9bc9310e1fc8dd6e221e5d23d5d47900915396"
      )
  ]
)
