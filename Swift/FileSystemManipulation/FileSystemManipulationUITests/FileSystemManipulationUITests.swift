import XCTest
import FileSystemManipulator

class FileSystemManipulationUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        let configuration = FileSystemManipulatorConfiguration()

        do {
            let dataURL = try writeStringToTemporaryFile("Injected Data!")
            configuration.copyFileAtURL(dataURL, toRelativePath: "Documents/data.txt")
        } catch let error {
            XCTFail("Failed to write data file: \(error)")
        }

        app.launchEnvironment = configuration.generateLaunchEnvironment()
        app.launch()
    }

    func testShowsTextLoadedFromFileInDocumentsDirectory() {
        XCTAssert(app.staticTexts["Injected Data!"].exists)
    }

    private func writeStringToTemporaryFile(string: String) throws -> NSURL {
        let filePath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent(NSProcessInfo.processInfo().globallyUniqueString)
        let fileURL = NSURL(fileURLWithPath: filePath)
        try string.writeToURL(fileURL, atomically: false, encoding: NSUTF8StringEncoding)
        return fileURL
    }
}
