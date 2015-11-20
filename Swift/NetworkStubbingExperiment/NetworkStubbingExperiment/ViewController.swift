import UIKit

class ViewController: UIViewController {
    let session = NSURLSession.sharedSession()
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let task = session.dataTaskWithURL(URLWithPath("hello")) { data, _, _ in
            guard let data = data, string = NSString(data: data, encoding: NSUTF8StringEncoding) else {
                return
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.label.text = string as String
            }
        }
        task.resume()
    }

    @IBAction func checkInTapped() {
        let request = NSMutableURLRequest(URL: URLWithPath("checkin"))
        request.HTTPMethod = "POST"
        request.HTTPBody = "Checking in".dataUsingEncoding(NSUTF8StringEncoding)

        session.dataTaskWithRequest(request).resume()
    }

    private func URLWithPath(path: String) -> NSURL {
        let baseURLString = NSProcessInfo.processInfo().environment[kServerURLEnvironmentKey] ?? "http://mycoolwebservice.com"
        return NSURL(string: path, relativeToURL: NSURL(string: baseURLString))!
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}
