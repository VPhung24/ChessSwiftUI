//
//  AppDelegate.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import SwiftUI
import CoinbaseWalletSDK

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (try? CoinbaseWalletSDK.shared.handleResponse(url)) == true {
            return true
        }
        
        // handle other types of deep links
        return false
    }
}
