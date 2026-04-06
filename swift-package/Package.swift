// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SwiftPackage",
    platforms: [.iOS(.v17), .macOS(.v14)],
    targets: [
        .executableTarget(
            name: "SwiftPackage",
            dependencies: [
                "Alamofire",
                "Kingfisher",
                "SnapKit",
                "SwiftyJSON",
            ],
            path: "Sources"),
    ]
)
