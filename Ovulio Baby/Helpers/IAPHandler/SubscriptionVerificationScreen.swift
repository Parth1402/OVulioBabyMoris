//
//  SubscriptionVerificationScreen.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 01.07.23.
//

import Foundation
import UIKit
import Hero
import SwiftyStoreKit

class SubscriptionVerificationScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImageView = CommonView.getCommonImageView(image: "appBackgroundImage")
        self.view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        let bottomBackgroundImageView = CommonView.getCommonImageView(image: "splashScreenInBackground")
        self.view.addSubview(bottomBackgroundImageView)
        NSLayoutConstraint.activate([
            bottomBackgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomBackgroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25),
            bottomBackgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomBackgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        let appNameImageView = CommonView.getCommonImageView(image: "splashScreenTextImage")
        appNameImageView.contentMode = .scaleAspectFit
        self.view.addSubview(appNameImageView)
        NSLayoutConstraint.activate([
            appNameImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            appNameImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            appNameImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            appNameImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.06),
        ])
        
        let splashUpperBackground = CommonView.getCommonImageView(image: "splashUpperBackground")
        splashUpperBackground.contentMode = .scaleAspectFit
        self.view.addSubview(splashUpperBackground)
        NSLayoutConstraint.activate([
            splashUpperBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            splashUpperBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            splashUpperBackground.topAnchor.constraint(equalTo: appNameImageView.bottomAnchor, constant: 60),
            splashUpperBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        // Spin config:
        let activityView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityView.style = .large
        } else {
            // Fallback on earlier versions
        }
        activityView.assignColor(UIColor.white)
        
        self.view.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30.0).isActive = true
        activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        activityView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        activityView.startAnimating()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.verifyPurchase()
        self.checkSubscriptions()
        
    }
    
    
    private func checkSubscriptions() {
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "didUnlockAppCompletely") == nil || userDefaults.value(forKey: "didUnlockAppCompletely") as! Bool == false {
            
            // User did NOT unlock App completely (for UGC's Creators)
            
            if isUserProMember() == false {
                
                // User is Free User
                self.delay(0.4) {
                    self.doAppFlow()
                }
                
            } else {
                
                // User is/was paid User last time he used app, now check if user is still paid user
                self.verifyPurchase()
                
            }
            
        } else {
            
            //InAppPurchaseManager.shared.isProUser = true
            
            // User unlocked App completely (for UGC's Creators)
            self.doAppFlow()
            
        }
        
    }
    
    
    func verifyPurchase() {
        
        // User Defaults
        let userDefaults = UserDefaults.standard
        var didOvulioBabyLifetimeSubscription: Bool = true
        if userDefaults.value(forKey: "didOvulioBabyLifetimeSubscription") == nil || userDefaults.value(forKey: "didOvulioBabyLifetimeSubscription") as! Bool == false {
            
            didOvulioBabyLifetimeSubscription = false
            
        }
        
        
        if didOvulioBabyLifetimeSubscription == true {
            
            doAppFlow()
            
        } else {
            
            NetworkActivityIndicatorManager.NetworkOperationStarted()
            verifyReceipt { result in
                
                NetworkActivityIndicatorManager.NetworkOperationFinished()
                
                switch result {
                    case .success(let receipt):
                        
                        let productIdWeekly = InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionWeekly.rawValue
                        let productIdMonthly = InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionMonthly.rawValue
                        let productId3Months = InAppPurchaseProduct.ovulioBabyUnlockAllSubscription3Months.rawValue
                        let productIdLifetime = InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionLifetime.rawValue
                        
                        // Verify the purchase of a Subscription
                        let purchaseResultWeekly = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable,
                            productId: productIdWeekly,
                            inReceipt: receipt)
                        
                        let purchaseResultMonthly = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable,
                            productId: productIdMonthly,
                            inReceipt: receipt)
                        
                        let purchaseResult3Months = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable,
                            productId: productId3Months,
                            inReceipt: receipt)
                    
                        let purchaseResultLifetime = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable,
                            productId: productIdLifetime,
                            inReceipt: receipt)
                        
                        let userDefaults = UserDefaults.standard
                        var isValidSubscription: Bool = false
                        
                        switch purchaseResultWeekly {
                        case .purchased(let expiryDate, let items):
                            print("\(purchaseResultWeekly) is valid until \(expiryDate)\n\(items)\n")
                            isValidSubscription = true
                            userDefaults.set(true, forKey: "didOvulioBabyWeeklySubscription")
                        case .expired(let expiryDate, let items):
                            print("\(purchaseResultWeekly) is expired since \(expiryDate)\n\(items)\n")
                            userDefaults.set(false, forKey: "didOvulioBabyWeeklySubscription")
                        case .notPurchased:
                            print("The user has never purchased \(purchaseResultWeekly)")
                            userDefaults.set(nil, forKey: "didOvulioBabyWeeklySubscription")
                        }
                        
                        switch purchaseResultMonthly {
                        case .purchased(let expiryDate, let items):
                            print("\(purchaseResultMonthly) is valid until \(expiryDate)\n\(items)\n")
                            isValidSubscription = true
                            userDefaults.set(true, forKey: "didOvulioBabyMonthlySubscription")
                        case .expired(let expiryDate, let items):
                            print("\(purchaseResultMonthly) is expired since \(expiryDate)\n\(items)\n")
                            userDefaults.set(false, forKey: "didOvulioBabyMonthlySubscription")
                        case .notPurchased:
                            print("The user has never purchased \(purchaseResultMonthly)")
                            userDefaults.set(nil, forKey: "didOvulioBabyMonthlySubscription")
                        }
                        
                        switch purchaseResult3Months {
                        case .purchased(let expiryDate, let items):
                            print("\(purchaseResultMonthly) is valid until \(expiryDate)\n\(items)\n")
                            isValidSubscription = true
                            userDefaults.set(true, forKey: "didOvulioBaby3MonthsSubscription")
                        case .expired(let expiryDate, let items):
                            print("\(purchaseResultMonthly) is expired since \(expiryDate)\n\(items)\n")
                            userDefaults.set(false, forKey: "didOvulioBaby3MonthsSubscription")
                        case .notPurchased:
                            print("The user has never purchased \(purchaseResultMonthly)")
                            userDefaults.set(nil, forKey: "didOvulioBaby3MonthsSubscription")
                        }
                        
                        switch purchaseResultLifetime {
                        case .purchased(let expiryDate, let items):
                            print("\(purchaseResultLifetime) is valid until \(expiryDate)\n\(items)\n")
                            isValidSubscription = true
                            userDefaults.set(true, forKey: "didOvulioBabyLifetimeSubscription")
                        case .expired(let expiryDate, let items):
                            print("\(purchaseResultLifetime) is expired since \(expiryDate)\n\(items)\n")
                            userDefaults.set(false, forKey: "didOvulioBabyLifetimeSubscription")
                        case .notPurchased:
                            print("The user has never purchased \(purchaseResultLifetime)")
                            userDefaults.set(nil, forKey: "didOvulioBabyLifetimeSubscription")
                        }
                        /*
                        if isValidSubscription == true {
                            userDefaults.set(true, forKey: "didPhotoPurgeWeeklySubscription")
                        } else {
                            userDefaults.set(false, forKey: "didPhotoPurgeWeeklySubscription")
                        }
                        */
                    case .error(let error):
                        print("Receipt verification failed: \(error)")
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(false, forKey: "didOvulioBabyWeeklySubscription")
                        userDefaults.set(false, forKey: "didOvulioBabyMonthlySubscription")
                        userDefaults.set(false, forKey: "didOvulioBaby3MonthsSubscription")
                        userDefaults.set(false, forKey: "didOvulioBabyLifetimeSubscription")
                    }
                
                
                self.doAppFlow()
                
            }
            
        }
        
    }
    
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
        
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    func doAppFlow() {
        
        DispatchQueue.main.async {
            
            let destinationViewController = HomeViewController()
            destinationViewController.modalPresentationStyle = .fullScreen
            self.present(destinationViewController, animated: false, completion: nil)
            
        }
        
    }
    
}
