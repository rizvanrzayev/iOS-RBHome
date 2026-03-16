import ProjectDescription
import RBTuistHelpers

let projectName = "iOS-RBHome"
let organizationName = "Rabitabank"
let bundleIdPrefix = "com.rabitabank.mb"

let project = Project(
    name: projectName,
    organizationName: organizationName,
    options: .options(
        disableSynthesizedResourceAccessors: true
    ),
    packages: [
        // Local RBHome package
        .package(path: "."),
    ],
    settings: .settings(
        base: [
            "IPHONEOS_DEPLOYMENT_TARGET": .string("16.0"),
            "SWIFT_VERSION": .string("5.10"),
            "SWIFT_PACKAGE_NAME": .string("RBHome"),
        ],
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ],
        defaultSettings: .recommended
    ),
    targets: [
        // MARK: - RBHomeDemoApp
        .target(
            name: "RBHomeDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundleIdPrefix)",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true,
                    ],
                    "APPLE_GROUP_ID": "group.com.rabitabank.features.rbhome.demo",
                    "BACKEND_DATAROID_SERVICE_KEY": "demo-key-not-used",
                    "DATAROID_KEY": "demo-dataroid-key",
                    "DATAROID_SERVER_URL": "demo-server-url",
                ]
            ),
            sources: ["DemoApp/**/*.swift"],
            resources: [
                "DemoApp/**/*.xib",
                "DemoApp/**/*.storyboard",
                "DemoApp/**/*.xcassets",
                "DemoApp/**/*.json"
            ],
            dependencies: [
                .package(product: "RBHome"),
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": .string(""),
                    "CODE_SIGN_STYLE": .string("Automatic"),
                    "LD_RUNPATH_SEARCH_PATHS": .array([
                        "$(inherited)",
                        "@executable_path/Frameworks",
                    ]),
                ],
                configurations: [
                    .debug(
                        name: .debug,
                        settings: [
                            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": .string("$(inherited) DEV"),
                        ]
                    ),
                    .release(
                        name: .release,
                        settings: [
                            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": .string("$(inherited)"),
                        ]
                    ),
                ]
            )
        ),
    ],
    schemes: [
        .scheme(
            name: "\(projectName)Demo",
            shared: true,
            buildAction: .buildAction(targets: [.target("RBHomeDemoApp")]),
            runAction: .runAction(executable: .target("RBHomeDemoApp"))
        )
    ]
)
