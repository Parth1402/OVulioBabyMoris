//
//  OptionsVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-27.
//

import UIKit
import Malert
import FirebaseFirestore
import MessageUI
import StoreKit
import SwiftyStoreKit
import SPAlert


class OptionsVC: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var customNavBarView: CustomNavigationBar?
    let reviewAlertView = ReviewAlertView()
    var malert: Malert? = nil
    
    // Define the data for your table view
    let sections = ["OptionsVC.Sections.Settings.headlineLabel.text"~,
                    "OptionsVC.Sections.Contacts.headlineLabel.text"~,]
    
    let settingsItems = ["OptionsVC.Settings.SetLanguage.headlineLabel.text"~,
                         "OptionsVC.Settings.RestorePurchase.headlineLabel.text"~,
                         "OptionsVC.Settings.Notifications.headlineLabel.text"~,
                         "OptionsVC.Settings.VisitWebsite.headlineLabel.text"~,
                         "OptionsVC.Settings.Legal.headlineLabel.text"~,
                         "OptionsVC.Settings.HowItWorks.headlineLabel.text"~]
    let contactsItems = [["image": "E-mail contact IMG", "title":
                            "OptionsVC.Contacts.E-mailContact.headlineLabel.text"~],
                         ["image": "Rate the app IMG", "title": "OptionsVC.Contacts.RateTheApp.headlineLabel.text"~],
                         ["image": "Follow in Instagram IMG", "title": "OptionsVC.Contacts.FollowInInstagram.headlineLabel.text"~],
                         ["image": "Share IMG", "title": "OptionsVC.Contacts.Share.headlineLabel.text"~],
                         ["image": "Our experts IMG", "title": "OptionsVC.Contacts.OurExperts.headlineLabel.text"~]]
    
    // Create a UITableView
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setUpBackground()
        setUpNavigationBar()
        addTableViewContent()
    }
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "closeButtonNotEnoughData"),
            titleString: "OptionsVC.headlineLabel.text"~
        )
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                self.dismiss(animated: true)
            }
            self.view.addSubview(customNavBarView)
            customNavBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customNavBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
        }
    }
    
    func addTableViewContent() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(OptionsTBLCell.self, forCellReuseIdentifier: "OptionsTBLCell")
        view.addSubview(tableView)
        
        if let customNavBarView = customNavBarView {
            tableView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressMoreTableView(sender:)))
        tableView.addGestureRecognizer(longPress)
        
    }
    
    @objc private func handleLongPressMoreTableView(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            // Success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                
                // Your code here, get the row for the indexPath or do whatever you want
                if indexPath.section == 0 && indexPath.row == 1 /*self.isUserProMember() == false*/ {
                    
                    // Declare Alert message
                    let dialogMessage = UIAlertController(title: NSLocalizedString("OptionsVC.alert.redeemCode.title", comment: ""), message: NSLocalizedString("OptionsVC.alert.redeemCode.message", comment: ""), preferredStyle: .alert)
                    dialogMessage.view.tintColor = UIColor.black
                    
                    // Add text field
                    dialogMessage.addTextField(configurationHandler: { textField in
                        textField.placeholder = NSLocalizedString("OptionsVC.alert.redeemCode.placeholder", comment: "")
                    })
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("Ok button tapped")
                        var activationCode = dialogMessage.textFields?.first?.text ?? ""
                        activationCode = activationCode.replacingOccurrences(of: " ", with: "")
                        print("Activation code = \(activationCode)")
                        
                        
                        if self.isActivationCodeValid(activationCode: activationCode) {
                            
                            self.redeemActivationCode(activationCode: activationCode)
                            
                        }
                        
                    })
                    
                    // Create Cancel button with action handlder
                    let cancel = UIAlertAction(title: NSLocalizedString("UIAlertController.cancelButton", comment: ""), style: .cancel) { (action) -> Void in
                        print("Cancel button tapped")
                    }
                    
                    //Add OK and Cancel button to dialog message
                    dialogMessage.addAction(ok)
                    dialogMessage.addAction(cancel)
                    
                    // Present dialog message to user
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                } else {
                    
                    restorePurchase()
                    
                }
                
            }
            
        }
        
    }
    
    
    func isActivationCodeValid(activationCode: String) -> Bool {
        
        // Check if Code is verified
        if activationCode.count != 12 {
            
            return false
            
        } else {
            
            // Activation Code length = 12
            if activationCode.suffix(2) == "2S" {
                
                // Activation Code can be valid, check Database
                return true
                
            } else {
                
                return false
                
            }
            
        }
        
    }
    
    
    @objc func redeemActivationCode(activationCode: String) {
        
        // Check Network Connection
        NetworkManager.isReachable { (managedNetwork) in
            
            let nowDate = Date()  // self.client.referenceTime?.now()
            //if nowDate != nil { }
            
            self.view.isUserInteractionEnabled = false
            self.addLoadingIndicator()
            
            let db = Firestore.firestore()
            let docRefActivationCodes = db.collection("activationCodes").document(activationCode)
            docRefActivationCodes.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    if let isActive = document.data()!["isActive"] as? Bool {
                        print("isActive \(isActive)")
                        
                        if isActive == false {
                            
                            // Activation Code is valid and can be used
                            
                            // Update Firestore Data
                            let activationDateFormate = nowDate.getFormattedDate(format: "dd-MM-yyyy")  // Set output formate
                            
                            let dict: [String: Any] = ["isActive": true, "activationDate": activationDateFormate]
                            docRefActivationCodes.setData(dict, merge: true)  { (err) in
                                
                                if err == nil {
                                    /*
                                    // Update monthly Tracking Data
                                    let currentDateMonthFormate = nowDate!.getFormattedDate(format: "MM-yyyy")  // Set output formate
                                    let docRefTracking = db.collection("tracking").document(currentDateMonthFormate)
                                    
                                    docRefTracking.getDocument { (document, error) in
                                        
                                        if let document = document, document.exists {
                                            
                                            docRefTracking.updateData(["activatedActivationCodes" : FieldValue.increment(Int64(1))])
                                            
                                        } else {
                                            
                                            docRefTracking.setData(["activatedActivationCodes" : 1], merge: true)
                                            
                                        }
                                        
                                    }
                                    */
                                    
                                    self.view.isUserInteractionEnabled = true
                                    self.removeLoadingIndicator()
                                    
                                    
                                    // Successful Activated
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.setValue(true, forKey: "didUnlockAppCompletely")
                                    //userDefaults.set(Date(), forKey: "purchaseDateScratchAdventurePro")
                                    
                                    
                                    // Feedback Generator
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    
                                    
                                    // Make Tick animation
                                    let alertView = AlertAppleMusic17View(title: NSLocalizedString("SalesVC.spalert.success.title", comment: NSLocalizedString("SalesVC.spalert.success.message", comment: "")), subtitle: "", icon: .heart)
                                    alertView.present(on: self.view)
                                    
                                } else {
                                    
                                    self.view.isUserInteractionEnabled = true
                                    self.removeLoadingIndicator()
                                    
                                    // Alert
                                    self.showAlert(title: NSLocalizedString("LoadingProcess.alert.error.title", comment: ""), message: NSLocalizedString("LoadingProcess.alert.error.message", comment: ""))
                                    
                                }
                                
                            }
                            
                        } else {
                            
                            // Error
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.error)
                            
                            self.view.isUserInteractionEnabled = true
                            self.removeLoadingIndicator()
                            
                            self.restorePurchase()
                            
                        }
                        
                    } else {
                        
                        // Error
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                        
                        self.view.isUserInteractionEnabled = true
                        self.removeLoadingIndicator()
                        
                        self.restorePurchase()
                        
                    }
                    
                } else {
                    
                    // Clear Text Fields
                    //self.arCodeTextField.text = ""
                    
                    // Error
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                    
                    self.view.isUserInteractionEnabled = true
                    self.removeLoadingIndicator()
                    
                    
                    self.restorePurchase()
                    
                }
                
            }
            
        }
        
        NetworkManager.isUnreachable { (managedNetwork) in
            
            DispatchQueue.main.async {
                
                // Error
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                
                // Alert
                self.showAlert(title: NSLocalizedString("LoadingProcess.alert.error.title", comment: ""), message: NSLocalizedString("LoadingProcess.alert.error.message", comment: ""))
                
            }
            
        }
        
    }
    
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = UIColor.black
        self.present(alert, animated: true)
        
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension OptionsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settingsItems.count
        } else {
            return contactsItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTBLCell", for: indexPath) as! OptionsTBLCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if indexPath.section == 0 {
            
            if indexPath.row == 0 || indexPath.row == 2 {
                cell.isHidden = true
            }
            
            cell.titleLabel.text = settingsItems[indexPath.row]
            cell.setupCell()
        } else {
            cell.titleLabel.text = contactsItems[indexPath.row]["title"]
            cell.itemImageView.image = UIImage(named: "\(contactsItems[indexPath.row]["image"]!)")
            cell.setupCell(isRightImageNeeded: true)
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        // Feedback Generator
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:  // Language
                break
            case 1:  // Restore Purchase
                restorePurchase()
                break
            case 2:
                let vc = NotificationsOptionVC()
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
                break
            case 3:  // Visit Website
                
                if let url = URL(string: "https://ovulio-baby.com") {
                    UIApplication.shared.open(url)
                }
                
                break
            case 4:  // Legal
                let vc = LegalOptionVC()
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
                break
            case 5:  // How the app works
                let vc = HowTheAppWorksVC()
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
                break
            default:
                break
            }
            break
        case 1:
            switch indexPath.row {
            case 0:  // E-Mail contact
                
                // Send Email
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["info@ovulio-baby.com"])
                    
                    mail.setSubject(NSLocalizedString("OptionsVC.keepInTouch.email", comment: ""))
                    //mail.setMessageBody("<p>Hello there, how can I change my Password</p>", isHTML: true)
                    
                    self.present(mail, animated: true)
                    
                } else {
                    // show failure alert
                }
                
                break
            case 1:  // App Review
                
                if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == true {
                    
                    DispatchQueue.main.async {
                        
                        let reviewAlertViewWidth = UIScreen.main.bounds.width * 0.85
                        let reviewAlertViewHeight = 300.0
                        self.reviewAlertView.isFunnelActive = false
                        self.reviewAlertView.rateButton.addTarget(self, action: #selector(self.rateButtonAction), for: .touchUpInside)
                        self.reviewAlertView.widthAnchor.constraint(equalToConstant: reviewAlertViewWidth).isActive = true
                        self.reviewAlertView.heightAnchor.constraint(equalToConstant: reviewAlertViewHeight).isActive = true
                        self.malert = Malert(customView: self.reviewAlertView)
                        self.malert!.backgroundColor = UIColor.clear
                        self.malert!.margin = 25.0
                        self.present(self.malert!, animated: true)
                        
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        // Ask for Review within App
                        if #available(iOS 10.3, *) {
                            SKStoreReviewController.requestReview()
                        }
                        
                    }
                    
                }
                
                break
            case 2:  // Follow on Instagram
                
                // Instagram
                let instagramHooks = "instagram://user?username=ovulio_baby"
                let instagramUrl = URL(string: instagramHooks)
                if UIApplication.shared.canOpenURL(instagramUrl!) {
                    
                    UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
                    
                } else {
                    
                    UIApplication.shared.open(URL(string: "https://instagram.com/ovulio_baby")!, options: [:], completionHandler: nil)
                    
                }
                
                break
            case 3:  // Share with friends
                
                // Alert
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.view.tintColor = appColor
                
                
                // Message
                let actionOne = UIAlertAction(title: NSLocalizedString("OptionsVC.shareCovarUIAlertController.messageButton", comment: ""), style: .default) { (action) in
                    
                    print("Message")
                    
                    if MFMessageComposeViewController.canSendText() {
                        let messageVC = MFMessageComposeViewController()
                        messageVC.messageComposeDelegate = self
                        messageVC.body = NSLocalizedString("OptionsVC.shareCovarUIAlertController.messageTextBody", comment: "")
                        //messageVC.recipients = ["12345678"]
                        
                        self.present(messageVC, animated: true, completion: nil)
                    } else {
                        print("Error")
                    }
                    
                }
                
                
                // E-Mail
                let actionTwo = UIAlertAction(title: NSLocalizedString("OptionsVC.shareCovarUIAlertController.emailButton", comment: ""), style: .default) { (action) in
                    
                    print("E-Mail")
                    
                    if MFMailComposeViewController.canSendMail() {
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        //mail.setToRecipients(["you@yoursite.com"])
                        mail.setSubject("Ovulio Baby")
                        mail.setMessageBody(NSLocalizedString("OptionsVC.shareCovarUIAlertController.emailTextBody", comment: ""), isHTML: false)
                        
                        self.present(mail, animated: true)
                    } else {
                        print("Error")
                    }
                    
                }
                
                
                // More
                let actionThree = UIAlertAction(title: NSLocalizedString("OptionsVC.shareCovarUIAlertController.moreButton", comment: ""), style: .default) { (action) in
                    
                    print("More")
                    
                    let textMessage = NSLocalizedString("OptionsVC.shareCovarUIAlertController.emailTextBody", comment: "")
                    let activityViewController = UIActivityViewController(activityItems: [textMessage], applicationActivities: nil)  // Add data to activityItem brackets
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    //activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.copyToPasteboard, UIActivityType.saveToCameraRoll, UIActivityType.print]
                    
                    self.present(activityViewController, animated: true, completion: nil)
                    
                }
                
                
                // Cancel
                let actionCancel = UIAlertAction(title: NSLocalizedString("UIAlertController.cancelButton", comment: ""), style: .cancel, handler: nil)
                
                // Add action to action sheet
                alert.addAction(actionOne)
                alert.addAction(actionTwo)
                alert.addAction(actionThree)
                alert.addAction(actionCancel)
                
                if let popoverController = alert.popoverPresentationController {
                    
                    popoverController.sourceView = self.view
                    //popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                    
                }
                
                // Present alert
                self.present(alert, animated: true, completion: nil)
                
                break
            case 4:
                let vc = OurExpertsOptionPageVC()
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
                break
            default:
                break
            }
            break
        default:
            break
        }
        
    }
    
    
    func restorePurchase() {
        
        self.addLoadingIndicator()
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        
        SwiftyStoreKit.restorePurchases(atomically: true, completion: {
            result in
            
            self.removeLoadingIndicator()
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            for purchase in result.restoredPurchases {
                
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                
                if purchase.productId == InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionWeekly.rawValue {
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(true, forKey: "didOvulioBabyWeeklySubscription")
                    userDefaults.set(Date(), forKey: "purchaseDateOvulioBabyPro")
                    
                    // Feedback Generator
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    // Make Tick animation
                    let alertView = AlertAppleMusic17View(title: NSLocalizedString("SalesVC.spalert.success.title", comment: NSLocalizedString("SalesVC.spalert.success.message", comment: "")), subtitle: "", icon: .heart)
                    alertView.present(on: self.view)
                    
                } else if purchase.productId == InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionMonthly.rawValue {
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(true, forKey: "didOvulioBabyMonthlySubscription")
                    userDefaults.set(Date(), forKey: "purchaseDateOvulioBabyPro")
                    
                    // Feedback Generator
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    // Make Tick animation
                    let alertView = AlertAppleMusic17View(title: NSLocalizedString("SalesVC.spalert.success.title", comment: NSLocalizedString("SalesVC.spalert.success.message", comment: "")), subtitle: "", icon: .heart)
                    alertView.present(on: self.view)
                    
                } else if purchase.productId == InAppPurchaseProduct.ovulioBabyUnlockAllSubscription3Months.rawValue {
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(true, forKey: "didOvulioBaby3MonthsSubscription")
                    userDefaults.set(Date(), forKey: "purchaseDateOvulioBabyPro")
                    
                    // Feedback Generator
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    // Make Tick animation
                    let alertView = AlertAppleMusic17View(title: NSLocalizedString("SalesVC.spalert.success.title", comment: NSLocalizedString("SalesVC.spalert.success.message", comment: "")), subtitle: "", icon: .heart)
                    alertView.present(on: self.view)
                    
                } else if purchase.productId == InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionLifetime.rawValue {
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(true, forKey: "didOvulioBabyLifetimeSubscription")
                    userDefaults.set(Date(), forKey: "purchaseDateOvulioBabyPro")
                    
                    // Feedback Generator
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    // Make Tick animation
                    let alertView = AlertAppleMusic17View(title: NSLocalizedString("SalesVC.spalert.success.title", comment: NSLocalizedString("SalesVC.spalert.success.message", comment: "")), subtitle: "", icon: .heart)
                    alertView.present(on: self.view)
                    
                } else if purchase.productId == InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionLifetime1.rawValue {
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(true, forKey: "didOvulioBabyLifetimeSubscription")
                    userDefaults.set(Date(), forKey: "purchaseDateOvulioBabyPro")
                    
                    // Feedback Generator
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    // Make Tick animation
                    let alertView = AlertAppleMusic17View(title: NSLocalizedString("SalesVC.spalert.success.title", comment: NSLocalizedString("SalesVC.spalert.success.message", comment: "")), subtitle: "", icon: .heart)
                    alertView.present(on: self.view)
                    
                }
                
                
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
            }
            
            self.showAlert(alert: self.alertForRestorePurchases(result: result))
            
        })
        
    }
    
    
    func showAlert(alert: UIAlertController?) {
        
        guard let _ = self.presentedViewController else {
            
            if alert != nil {
                self.present(alert!, animated: true, completion: nil)
            }
            
            return
            
        }
        
    }
    
    
    func alertForRestorePurchases(result: RestoreResults) -> UIAlertController? {
        
        if result.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(result.restoreFailedPurchases)")
            return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForRestorePurchases.restoreFailedPurchases.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForRestorePurchases.restoreFailedPurchases.message", comment: ""))
        } else if result.restoredPurchases.count > 0 {
            print("Restore Success: \(result.restoredPurchases)")
            return nil
            //return alertPurchaseSuccessRestartApp(title: NSLocalizedString("InAppPurchase.alertForRestorePurchases.restoredPurchases.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForRestorePurchases.restoredPurchases.message", comment: ""))
        } else {
            print("Nothing to Restore")
            return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForRestorePurchases.nothingToRestore.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForRestorePurchases.nothingToRestore.message", comment: ""))
        }
        
    }
    
    
    func alertWithTitle(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = appColor
        alert.addAction(UIAlertAction(title: NSLocalizedString("UIAlertController.okButton", comment: ""), style: .cancel, handler: nil))
        
        return alert
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let headerHeadlineLabel = CommonView.getCommonLabel(text: sections[section], textColor: lightAppColor, font: .boldSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14))
        headerView.addSubview(headerHeadlineLabel)
        NSLayoutConstraint.activate([
            headerHeadlineLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerHeadlineLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            headerHeadlineLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerHeadlineLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 2 {
                return 0.0
            }
        }
        
        return UITableView.automaticDimension
        
    }
    
}

extension OptionsVC {
    
    @objc func rateButtonAction() {
        
        // User Defaults
        let userDefaults = UserDefaults.standard
        var didUserGiveRating: Bool = false
        if userDefaults.value(forKey: "didUserGiveRating") != nil {
            didUserGiveRating = userDefaults.value(forKey: "didUserGiveRating") as! Bool
        }
        
        userDefaults.setValue(self.reviewAlertView.starRatingView.value, forKey: "userStarRating")
        
        
        let ratingToString = String(format: "%.0f", self.reviewAlertView.starRatingView.value)
        
        if didUserGiveRating == false {
            
            // Update Database Ratings
            let db = Firestore.firestore()
            let docRefTracking = db.collection("tracking").document("SubmittedRatingViaRatingView")
            docRefTracking.updateData(["submittedRatings" : FieldValue.increment(Int64(1))])
            
            docRefTracking.updateData([ratingToString + "StarRatings" : FieldValue.increment(Int64(1))])  // like "2StarRatings", "4StarRatings" or "5StarRatings"
            
        }
        
        if self.reviewAlertView.starRatingView.value <= 3 {
            
            // Contact Us selected, redirect to E-Mail form
            print("Contact Us selected, redirect to E-Mail form")
            
            // User Defaults
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(true, forKey: "didUserGiveRating")  // User did give rating successfully
            
//            if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_6_56_0) == true {
                
                DispatchQueue.main.async {
                    
                    if MFMailComposeViewController.canSendMail() {
                        
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setToRecipients(["info@ovulio-baby.com"])
                        mail.setSubject(NSLocalizedString("OptionsVC.ratingView.email.subject", comment: ""))
                        
                        if self.reviewAlertView.starRatingView.value == 1 {
                            mail.setMessageBody(NSLocalizedString("OptionsVC.ratingView.email.messageBody.star", comment: ""), isHTML: false)
                        } else {
                            mail.setMessageBody(NSLocalizedString("OptionsVC.ratingView.email.messageBody.stars", comment: "").replacingOccurrences(of: "%x", with: ratingToString), isHTML: false)
                        }
                        
                        self.present(mail, animated: true)
                        
                    } else {
                        // show failure alert
                    }
                    
                }
                
//            }
            
        } else {
            
            // Rate Us selected, redirect to App Store
            print("Rate Us selected, redirect to App Store")
            
            // User Defaults
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(true, forKey: "didUserGiveRating")  // User did give rating successfully
            userDefaults.setValue(true, forKey: "shouldAskUserForAppStoreRating")  // Next Time in viewDidLoad in OptionsVC ask user for App Store Review
            
            
            DispatchQueue.main.async {
                
                let appId = "6469041230"
                let url = "itms-apps://itunes.apple.com/app/id\(appId)?mt=8&action=write-review"
                
                guard let url = URL(string: url) else {
                    return
                }
                
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            }
            
        }
        
        self.malert?.dismiss(animated: true)
        
    }
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        /*
        if result == MessageComposeResult.cancelled {
            controller.dismiss(animated: true, completion: nil)
        }
        */
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        /*
        if result == MFMailComposeResult.cancelled {
            controller.dismiss(animated: true, completion: nil)
        }
        */
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
}
