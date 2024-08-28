# Installation
```bash
brew tap michaelversus/swiftarchdiagram https://github.com/michaelversus/SwiftArchDiagram
brew install swiftarchdiagram
```
# Usage
First step is to update the internal Packages using some special comments to help swiftarchdiagram draw the diagram for your architecture like this:
```swift
import PackageDescription

// swift-arch-target: DPNetworking
// swift-arch-layer: Foundation
// swift-arch-level: 2

let package = Package(
    name: "DPNetworking",
    products: [
        .library(
            name: "DPNetworking",
            targets: ["DPNetworking"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1")
    ],
    targets: [
        .target(
            name: "DPNetworking",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .testTarget(
            name: "DPNetworkingTests",
            dependencies: ["DPNetworking"]
        ),
    ]
)
```
Example project [here](https://github.com/michaelversus/SwiftArchDiagramDemoProject)

Second step execute the followong command:
```bash
swiftarchdiagram --directory ~/App/Packages --rpath ~/App/SomeApp.xcworkspace/xcshareddata/swiftpm/Package.resolved --with-relations --should-wrap
```
- **directory**: the internal Swift Packages directory that you are using if any
- **rpath**: the path of the main Package.resolved for your project or workspace. (Optional)
- **with-relations**: add arrows to display dependencies between packages (Optional)
- **should-wrap**: adds the '''mermaid prefix for the output md file

The above command will generate an Architecture.md file that contains the mermaid diagram for your app like this

# Example

```bash
block-beta
columns 1
	block:AppSDKs
		alamofire
		combine.schedulers
		kingfisher
		swift.clocks
	end
	block:AppSDKs4
		swift.concurrency.extras
		swift.dependencies
		swift.syntax
		xctest.dynamic.overlay
	end
	blockArrowIdT9999<["3rd party SDKs"]>(up)
	App(("APP"))
	blockArrowId1<["Framework"]>(down)
	block:Framework
		DPCommonUI
	end
	blockArrowId2<["Foundation"]>(down)
	block:Foundation
		DPNetworking
		DPCommonAssets
		DPCommonUIUtilities
	end
	blockArrowIdB9999<["3rd Party SDKs"]>(down)
	block:3rd_Party_SDKs
		Kingfisher
		Alamofire
	end

	%% Relations between modules
	DPCommonUI ---> Kingfisher
	DPCommonUI ---> DPCommonAssets

	DPNetworking ---> Alamofire
```

You can also use the LiveEditor tool [here](https://mermaid.js.org/) to preview the diagram and export to your preferred format

[![](https://mermaid.ink/img/pako:eNp1U21r2zAQ_itGUEggMVbceIkZhbAwKGUjrPTLplEU6ZKIWJKR5CVeyH-fLKdN7XbfdHfPPffci06IaQ4oR-tCs_14DY4SxXRRSWUjTBRxIZAvyvJx-WAbB3G0oFJvhIHWZFquhYLYsh3wqgBzge2F2m6E3YFpbXsQGxezhi8gQPF3BW47UK1YZQwoVsdwdIbat1EOpWfwQQEdv62Vo8fWc2QOrIfWikrBYv0HTEHrfvGFMfpwz-effxGUGh6V1Lg6Cv2i33eDqhw2UK9wMCBosVoRNBz2k3GT_NVQCQdt9iGP64O64vJrMEhbrr5oKbV6uv-PnElg1JXi1AmtPqS8Ri-c38E1Jfzku1UW1oKz_cpPThTCXeb3gYT0ZSKr7kR6MjziOSCerzfy0Fv-4u3NtKX84-Ym-gFF6MBG_vgOACqSurmiwHOVGo3H47uoy9qPvmtWdUfSol6VoBGSYCQV3N__iagoIsjtQAJBuX9y2uyRqLPH0crpx1oxlDtTwQgZXW13KN_QwnqrKv0SYCno1q_4BQJcOG2-tb8rfLIRKqn6qbV8TfQ2yk_oiHKMZ_HkUzpPkzSZzpMUZyNUozz17jRLpzjFt9ksw_g8Qn8DQxLPk1mC53g2TbJsMknx-R9RbVxX?type=png)](https://mermaid.live/edit#pako:eNp1U21r2zAQ_itGUEggMVbceIkZhbAwKGUjrPTLplEU6ZKIWJKR5CVeyH-fLKdN7XbfdHfPPffci06IaQ4oR-tCs_14DY4SxXRRSWUjTBRxIZAvyvJx-WAbB3G0oFJvhIHWZFquhYLYsh3wqgBzge2F2m6E3YFpbXsQGxezhi8gQPF3BW47UK1YZQwoVsdwdIbat1EOpWfwQQEdv62Vo8fWc2QOrIfWikrBYv0HTEHrfvGFMfpwz-effxGUGh6V1Lg6Cv2i33eDqhw2UK9wMCBosVoRNBz2k3GT_NVQCQdt9iGP64O64vJrMEhbrr5oKbV6uv-PnElg1JXi1AmtPqS8Ri-c38E1Jfzku1UW1oKz_cpPThTCXeb3gYT0ZSKr7kR6MjziOSCerzfy0Fv-4u3NtKX84-Ym-gFF6MBG_vgOACqSurmiwHOVGo3H47uoy9qPvmtWdUfSol6VoBGSYCQV3N__iagoIsjtQAJBuX9y2uyRqLPH0crpx1oxlDtTwQgZXW13KN_QwnqrKv0SYCno1q_4BQJcOG2-tb8rfLIRKqn6qbV8TfQ2yk_oiHKMZ_HkUzpPkzSZzpMUZyNUozz17jRLpzjFt9ksw_g8Qn8DQxLPk1mC53g2TbJsMknx-R9RbVxX)
