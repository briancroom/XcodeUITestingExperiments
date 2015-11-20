import XCTest

class NetworkStubbingExperimentUITests: XCTestCase {
    let app = XCUIApplication()
    let webServer = MockWebServer()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        do {
            try webServer.start()
        } catch let error {
            XCTFail("Failed to start server: \(error)")
        }

        app.launchEnvironment = [ kServerURLEnvironmentKey: webServer.baseURL.absoluteString ]
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        webServer.stop()
    }

    func testLoadsAndDisplaysTextFromServer() {
        let loadedText = app.staticTexts["Hello World!"]
        let existsPredicate = NSPredicate(format: "exists==YES", argumentArray: nil)
        expectationForPredicate(existsPredicate, evaluatedWithObject: loadedText, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)

        XCTAssert(loadedText.exists)
    }

    func testTappingButtonSendsCheckinPost() {
        let expectedString = "Checking in"
        keyValueObservingExpectationForObject(webServer, keyPath: "postedString", expectedValue: expectedString)

        app.buttons["Check In"].tap()

        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssertEqual(webServer.postedString, expectedString)
    }
}
