# AppUpdater

A package to simply fetch an app's current store version (major.minor.patch). This can be used to test whether a user has the same version of your app as is in the App Store.

That's all there is to it. Playground included. Tests included.

``` swift
import AppUpdater
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let earlierVersion = AppVersion(major: 2, minor: 8, patch: 1)
let laterVersion = AppVersion("2.9.110")!
let currentVersion = AppVersion(major: 2, minor: 9, patch: 23)

assert(currentVersion > earlierVersion)
assert(laterVersion > currentVersion)

AppVersion.storeVersion(bundleId: "com.myCompany") { result in
    switch result {
    case .success(let (storeVersion, storeUrl)):
        if currentVersion < storeVersion {
            print("Download the latest version here: \(storeUrl)")
        }
        
    case .failure(let error):
        print(error.localizedDescription)
    }
    PlaygroundPage.current.finishExecution()
}
```
