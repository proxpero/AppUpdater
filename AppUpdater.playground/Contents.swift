import AppUpdater
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let earlierVersion = AppVersion(major: 2, minor: 8, patch: 1)
let laterVersion = AppVersion("2.9.110")!
let currentVersion = AppVersion(major: 2, minor: 9, patch: 23)

assert(currentVersion > earlierVersion)
assert(laterVersion > currentVersion)

// Replace `com.myCompany` with the bundle id of your app. You can find it in the info.plist file.
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

// In your app, you can load a device's current app version from the main bundle using the extension:
import Foundation
let version = Bundle.main.appVersion // This fails in a playground because playgrounds don't have versions.
