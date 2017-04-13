
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let pageVC = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        let pageViewModel = PageViewModel()
        pageVC.bindViewModel(pageViewModel)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = pageVC
        window?.makeKeyAndVisible()
        
        return true
    }

}

