import XCTest
@testable import AppUpdater

final class AppUpdaterTests: XCTestCase {
    func testStringInit() {
        XCTAssertEqual(
            AppVersion.init("1.9.13"),
            AppVersion(major: 1, minor: 9, patch: 13)
        )
        XCTAssertEqual(
            AppVersion.init("42.09.3909"),
            AppVersion(major: 42, minor: 9, patch: 3909)
        )
        XCTAssertNil(AppVersion("1.2.9rc1"))
        XCTAssertNil(AppVersion("1.2"))
        XCTAssertNil(AppVersion("1..9"))
    }

    func testComparison() {
        let earlierVersion = AppVersion(major: 2, minor: 8, patch: 1)
        let laterVersion = AppVersion(major: 2, minor: 9, patch: 110)
        let currentVersion = AppVersion(major: 2, minor: 9, patch: 23)

        XCTAssertTrue(earlierVersion < currentVersion)
        XCTAssertTrue(currentVersion < laterVersion)
    }

    static var allTests = [
        ("testStringInit", testStringInit),
        ("testComparison", testComparison)
    ]
}
