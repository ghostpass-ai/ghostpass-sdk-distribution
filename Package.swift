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
          url: "https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.1.5/GoPassSDK.xcframework.zip",
          checksum: "252e94d27d650179c284c5f29de8110d85596a24a248e8b57d44f163dd95a65a"
      )
  ]
)
