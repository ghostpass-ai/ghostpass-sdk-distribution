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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.2/GoPassSDK.xcframework.zip",
          checksum: "40953012f5df75135fe4795d30baaf15cc4efb2fb84d7e5c91cd9bcdb18f77a6"
      )
  ]
)
