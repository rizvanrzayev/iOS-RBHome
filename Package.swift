// swift-tools-version: 5.10

import PackageDescription
import Foundation

private let rbSharedRepoRoot = "../../RemotePackages"

private enum RBPackageMode {
    case local
    case remote
    case auto
}

private extension Package.Dependency {
    static func rbPackage(
        _ repoName: String,
        localRepoRoot: String,
        mode: RBPackageMode = .auto
    ) -> PackageDescription.Package.Dependency {
        let useLocal: Bool = {
            switch mode {
            case .local:
                return true
            case .remote:
                return false
            case .auto:
                return ProcessInfo.processInfo.environment["USE_LOCAL_PACKAGES"] == "1"
            }
        }()

        if useLocal {
            return .package(path: "\(localRepoRoot)/\(repoName)")
        } else {
            return .package(url: "https://github.com/RabitaBank/\(repoName).git", branch: "master")
        }
    }
}

let package = Package(
    name: "RBHome",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "RBHome",
            targets: ["RBHome"]
        )
    ],
    dependencies: [
        .designSystem, .navigation, .common, .domain, .networking, .data, .analytics
    ],
    targets: [
        .target(
            name: "RBHomeDomain",
            dependencies: [
                .product(name: "Domain", package: "iOS-RBDomain"),
                .product(name: "Common", package: "iOS-RBCommon"),
            ]
        ),
        .target(
            name: "RBHomeData",
            dependencies: [
                "RBHomeDomain",
                .product(name: "Networking", package: "iOS-RBNetworking"),
                .product(name: "Data", package: "iOS-RBData"),
                .product(name: "Common", package: "iOS-RBCommon"),
            ]
        ),
        .target(
            name: "RBHomePresentation",
            dependencies: [
                "RBHomeDomain",
                "RBHomeData",
                .product(name: "RBDesignSystem", package: "iOS-RBSwiftUIDesignSystem"),
                .product(name: "RBNavigation", package: "iOS-RBNavigation"),
                .product(name: "Common", package: "iOS-RBCommon"),
            ],
            resources: [.process("Resources")]
        ),
        .target(
            name: "RBHome",
            dependencies: [
                "RBHomeDomain",
                "RBHomeData",
                "RBHomePresentation",
                .product(name: "Common", package: "iOS-RBCommon"),
            ]
        ),
        .testTarget(
            name: "RBHomeTests",
            dependencies: ["RBHome"]
        ),
    ]
)

extension PackageDescription.Package.Dependency {

    static let designSystem: PackageDescription.Package.Dependency =
        .rbPackage("iOS-RBSwiftUIDesignSystem", localRepoRoot: rbSharedRepoRoot)

    static let navigation: PackageDescription.Package.Dependency =
        .rbPackage("iOS-RBNavigation", localRepoRoot: rbSharedRepoRoot)

    static let common: PackageDescription.Package.Dependency =
        .rbPackage("iOS-RBCommon", localRepoRoot: rbSharedRepoRoot)

    static let domain: PackageDescription.Package.Dependency =
        .rbPackage("iOS-RBDomain", localRepoRoot: rbSharedRepoRoot)

    static let networking: PackageDescription.Package.Dependency =
        .rbPackage("iOS-RBNetworking", localRepoRoot: rbSharedRepoRoot)

    static let data: PackageDescription.Package.Dependency =
        .rbPackage("iOS-RBData", localRepoRoot: rbSharedRepoRoot)

    static let analytics: PackageDescription.Package.Dependency =
        .rbPackage("iOS-RBAnalytics", localRepoRoot: rbSharedRepoRoot)
}
