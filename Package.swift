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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.1.3/GoPassSDK.xcframework.zip",
          checksum: "63a11461977c987a1911843a731e4249241cd511bfebada72e8096aa6ff0bc12"
      )
  ]
)
