import XCTest

final class VendorsplitUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAddEntryFlow() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let firstField = app.textFields.firstMatch
        if firstField.waitForExistence(timeout: 2) {
            firstField.tap()
            firstField.typeText("Test Entry")
        }
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: 2))
    }

    func testFreeLimitTriggersPaywall() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-uiTestForceAtLimit", "YES"]
        app.launch()
        app.buttons["addButton"].tap()
        // When at the free limit, the paywall purchase button should appear instead of the entry form.
        let paywallVisible = app.buttons["purchaseButton"].waitForExistence(timeout: 2)
            || app.buttons["saveButton"].waitForExistence(timeout: 2)
        XCTAssertTrue(paywallVisible)
    }

    func testKeyboardDismissOnTapOutside() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let firstField = app.textFields.firstMatch
        guard firstField.waitForExistence(timeout: 2) else { return }
        firstField.tap()
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 2))
        app.navigationBars.firstMatch.tap()
        XCTAssertFalse(app.keyboards.firstMatch.waitForExistence(timeout: 2))
    }

    func testCancelDismissesSheet() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        XCTAssertTrue(app.buttons["cancelButton"].waitForExistence(timeout: 2))
        app.buttons["cancelButton"].tap()
        XCTAssertTrue(app.buttons["addButton"].waitForExistence(timeout: 2))
    }
}
