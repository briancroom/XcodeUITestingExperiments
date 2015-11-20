import UIKit

class ViewController: UIViewController {
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = loadedText() ?? "No data found!"
    }

    func loadedText() -> String? {
        let filename = "data.txt"
        guard let dataURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first?.URLByAppendingPathComponent(filename) else {
            return nil
        }
        return (try? NSString(contentsOfURL: dataURL, encoding: NSUTF8StringEncoding)) as String?
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}
