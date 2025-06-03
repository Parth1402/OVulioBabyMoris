//
//  AppDelegate.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-07.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyStoreKit
import Siren
import TrueTime
import FirebaseCore
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerLibDelegate {
    
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.isEnabled = true
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = false
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
        FirebaseApp.configure()
        
        _ = RCValues.sharedInstance
        
        
        // At an opportune time (e.g. app start):
        TrueTimeClient.sharedInstance.start()
        
        // Siren checks a user's currently installed version of Scratch Adventure
        let siren = Siren.shared
        let rules = Rules(promptFrequency: .daily, forAlertType: .option)
        siren.rulesManager = RulesManager(globalRules: rules)
        siren.wail()
        
        // Apps Flyer
        AppsFlyerLib.shared().appsFlyerDevKey = "TfyLaLLxXh9S8AzgQHuY6f"
        AppsFlyerLib.shared().appleAppID = "6469041230"
        
        /* Uncomment the following line to see AppsFlyer debug logs */
        // AppsFlyerLib.shared().isDebug = true
        // Must be called AFTER setting appsFlyerDevKey and appleAppID
        AppsFlyerLib.shared().delegate = self
        
        return true
        
    }
    
    
    // SceneDelegate support - start AppsFlyer SDK
    @objc func didBecomeActiveNotification() {
        //AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)  // App Tracking Transparency (ATT)
        AppsFlyerLib.shared().start()
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    // AppsFlyer
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        
    }
    
    func onConversionDataFail(_ error: Error) {
        
    }
    
}
