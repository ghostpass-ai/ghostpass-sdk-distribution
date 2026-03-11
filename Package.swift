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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.1.4/GoPassSDK.xcframework.zip",
          checksum: "d8f60240633dceb43215511b2f75396890efd603a21c07634a93ba856faa86ec"
      )
  ]
)
