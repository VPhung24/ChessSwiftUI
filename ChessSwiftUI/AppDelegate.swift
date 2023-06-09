import SwiftUI
import CoinbaseWalletSDK

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.swizzleOpenURL()

        CoinbaseWalletSDK.configure(callback: URL(string: "lucena://mycallback")!)
        
        return true
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (try? CoinbaseWalletSDK.shared.handleResponse(url)) == true {
            return true
        }

        // handle other types of deep links
        return false
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL,
           (try? CoinbaseWalletSDK.shared.handleResponse(url)) == true {
            return true
        }
        // handle other types of deep links
        return false
    }

}

let kOpenExternalURLNotification = Notification.Name("kOpenExternalURLNotification")

extension UIApplication {
    static func swizzleOpenURL() {
        guard
            let original = class_getInstanceMethod(UIApplication.self, #selector(open(_:options:completionHandler:))),
            let swizzled = class_getInstanceMethod(UIApplication.self, #selector(swizzledOpen(_:options:completionHandler:)))
        else { return }
        method_exchangeImplementations(original, swizzled)
    }

    @objc func swizzledOpen(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?) {
        NotificationCenter.default.post(
            name: kOpenExternalURLNotification,
            object: url
        )

        // it's not recursive. below is actually the original open(_:) method
        self.swizzledOpen(url, options: options, completionHandler: completion)
    }
}
