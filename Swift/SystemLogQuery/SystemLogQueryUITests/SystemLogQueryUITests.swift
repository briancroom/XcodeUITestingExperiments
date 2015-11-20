import XCTest
import LogDumper

class SystemLogQueryUITests: XCTestCase {
    let app = XCUIApplication()
    let query = SystemLogQuery.queryForFutureMessagesFromTestTargetApplication()!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app.launchEnvironment = [ "DYLD_INSERT_LIBRARIES": NSBundle(forClass: LogDumper.self).executablePath ?? "" ]
        app.launch()
    }

    func testLog() {
        XCTAssert(query.messages().contains("App loaded!"))
    }

    func testTappingButtonPersistsToUserDefaults() {
        let expectedString = "UserTappedButton = 1"

        XCTAssertFalse(dumpedLog().containsString(expectedString))

        expectationForLogContaining(expectedString)
        app.buttons["Tap me!"].tap()

        LogDumper.sendLogDumpRequest()
        waitForExpectationsWithTimeout(5, handler: nil)
    }

    private func dumpedLog() -> String {
        LogDumper.sendLogDumpRequestAndWaitForAcknowledgement()
        return query.messages().last ?? ""
    }

    private func expectationForLogContaining(expectedMessageFragment: String) -> XCTestExpectation {
        let predicate = NSPredicate { (query, _) -> Bool in
            return ((query as! SystemLogQuery).messages().last ?? "").containsString(expectedMessageFragment)
        }
        return expectationForPredicate(predicate, evaluatedWithObject: query, handler: nil)
    }
}
