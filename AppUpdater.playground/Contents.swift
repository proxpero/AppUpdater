import AppUpdater
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let earlierVersion = AppVersion(major: 2, minor: 8, patch: 1)
let laterVersion = AppVersion("2.9.110")!
let currentVersion = AppVersion(major: 2, minor: 9, patch: 23)

currentVersion > earlierVersion
laterVersion > currentVersion

AppVersion.storeVersion(bundleId: "com.myCompany") { result in
    switch result {
    case .success(let (version, url)):
        print(version, url)
    case .failure(let error):
        print(error.localizedDescription)
    }
    PlaygroundPage.current.finishExecution()
}
