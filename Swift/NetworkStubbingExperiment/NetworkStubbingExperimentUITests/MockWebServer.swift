import Foundation
import GCDWebServers

@objc class MockWebServer: NSObject {
    let baseURL = NSURL(string: "http://localhost:\(serverPort)")!
    dynamic private(set) var postedString: String?

    private static let serverPort = 8080

    private let webServer = GCDWebServer()

    func start() throws {
        setupHandlers()

        try webServer.startWithOptions([
            GCDWebServerOption_Port: MockWebServer.serverPort,
            GCDWebServerOption_AutomaticallySuspendInBackground: false ])
    }

    func stop() {
        webServer.stop()
    }

    private func setupHandlers() {
        let helloData = "Hello World!".dataUsingEncoding(NSUTF8StringEncoding)
        webServer.addGETHandlerForPath("/hello", staticData: helloData, contentType: "text/plain", cacheAge: 0)

        webServer.addHandlerForMethod("POST", path: "/checkin", requestClass: GCDWebServerDataRequest.self) { [weak self] request -> GCDWebServerResponse! in
            let dataRequest = request as! GCDWebServerDataRequest
            self?.postedString = String(data: dataRequest.data, encoding: NSUTF8StringEncoding)

            return GCDWebServerResponse(statusCode: 200)
        }
    }
}