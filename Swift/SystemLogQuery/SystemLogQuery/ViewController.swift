import UIKit

class ViewController: UIViewController {
    let userDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("App loaded!")

        userDefaults.removeObjectForKey("UserTappedButton")
    }

    @IBAction func buttonTapped() {
        userDefaults.setBool(true, forKey: "UserTappedButton")
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}
