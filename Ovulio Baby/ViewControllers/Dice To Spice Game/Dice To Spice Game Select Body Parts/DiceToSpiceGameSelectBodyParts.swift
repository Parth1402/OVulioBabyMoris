//
//  DiceToSpiceGameSelectBodyParts.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 21.10.22.
//

import Foundation
import UIKit
import Device


class DiceToSpiceGameSelectBodyParts: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let backButton: UIButton = {
        
        let buttonClose = UIButton()
        buttonClose.contentMode = .scaleAspectFit
        buttonClose.setImage(UIImage(named: "backButtonImg"), for: .normal)
        return buttonClose
    }()

    
    let headlineLabel: UILabel = {
        
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.font = UIFont(name: "Poppins-Bold", size: 24.0)
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .center
        labelHeadline.adjustsFontSizeToFitWidth = true
        labelHeadline.numberOfLines = 2
        
        return labelHeadline
        
    }()
    
    
    let subtitleLabel: UILabel = {
        
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.font = .systemFont(ofSize: 14.pulse2Font())
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .center
        labelHeadline.adjustsFontSizeToFitWidth = true
        labelHeadline.numberOfLines = 0
        
        return labelHeadline
        
    }()
    
    
    let actionsHeadlineLabel: UILabel = {
        
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.font = UIFont(name: "Teko-Bold", size: 24.0)
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .left
        labelHeadline.adjustsFontSizeToFitWidth = true
        labelHeadline.numberOfLines = 1
        
        return labelHeadline
        
    }()
    
    let actionsTableView = UITableView()
    var actionsTableViewCellId = "actionsTableViewCellId"
    
    
    let addCustomActionsButton: UIButton = {
        
        let buttonCustomMessage = CommonView.getCommonButton(title: "DiceToSpiceGameSelectBodyParts.addCustomActionsButton.title"~, font: .mymediumSystemFont(ofSize: 16.pulseWithFont(withInt: 1)))
        
        return buttonCustomMessage
        
    }()
    
    
    let bodyPartsHeadlineLabel: UILabel = {
        
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.font = UIFont(name: "Teko-Bold", size: 24.0)
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .left
        labelHeadline.adjustsFontSizeToFitWidth = true
        labelHeadline.numberOfLines = 1
        
        return labelHeadline
        
    }()
    
    let bodyPartsTableView = UITableView()
    var didAnimateTableViewCellsOnce: Bool = false
    
    var bodyPartsTableViewCellId = "bodyPartsTableViewCellId"
    
    
    let addCustomBodyPartButton: UIButton = {
        
        let buttonCustomMessage = CommonView.getCommonButton(title: "DiceToSpiceGameSelectBodyParts.addCustomBodyPartButton.title"~, font: .mymediumSystemFont(ofSize: 16.pulseWithFont(withInt: 1)))
        return buttonCustomMessage
        
    }()
    
    
    var selectedBodyParts: [Int] = []
    var customBodyParts: [String] = []
    
    var selectedActions: [Int] = []
    var customActions: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setUpBackground()
        
        
        // User Defaults
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "selectedBodyPartsDiceGame") != nil {
            self.selectedBodyParts = userDefaults.value(forKey: "selectedBodyPartsDiceGame") as! [Int]
        }
        
        if userDefaults.value(forKey: "customBodyPartsDiceGame") != nil {
            self.customBodyParts = userDefaults.value(forKey: "customBodyPartsDiceGame") as! [String]
        }
        
        if userDefaults.value(forKey: "selectedActionsDiceGame") != nil {
            self.selectedActions = userDefaults.value(forKey: "selectedActionsDiceGame") as! [Int]
        }
        
        if userDefaults.value(forKey: "customActionsDiceGame") != nil {
            self.customActions = userDefaults.value(forKey: "customActionsDiceGame") as! [String]
        }
        
        
        
        self.view.addSubview(headlineLabel)
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        headlineLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        headlineLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        
        headlineLabel.text = NSLocalizedString("DiceToSpiceGameSelectBodyParts.headlineLabel.text", comment: "")
        
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            //headlineLabel.font = .boldSystemFont(ofSize: 26)
        }
        
        
        
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.headlineLabel.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        backButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        
        // Button Animation
        backButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        backButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchDragOutside)
        
        
        
        
        
        self.view.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.topAnchor.constraint(equalTo: self.headlineLabel.bottomAnchor, constant: 0.0).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        
        subtitleLabel.text = NSLocalizedString("DiceToSpiceGameSelectBodyParts.subtitleLabel.text", comment: "")
        
        
        
        
        
        self.view.addSubview(addCustomBodyPartButton)
        addCustomBodyPartButton.translatesAutoresizingMaskIntoConstraints = false
        addCustomBodyPartButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0).isActive = true
        addCustomBodyPartButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            addCustomBodyPartButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        } else {
            addCustomBodyPartButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        }
        addCustomBodyPartButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        addCustomBodyPartButton.addTarget(self, action: #selector(addCustomBodyPartButtonAction), for: .touchUpInside)
        
        // Button Animation
        addCustomBodyPartButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        addCustomBodyPartButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        addCustomBodyPartButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        
        
        
        self.view.addSubview(bodyPartsHeadlineLabel)
        bodyPartsHeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyPartsHeadlineLabel.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60.0).isActive = true
        bodyPartsHeadlineLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        bodyPartsHeadlineLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30.0).isActive = true
        
        bodyPartsHeadlineLabel.text = NSLocalizedString("DiceToSpiceGameSelectBodyParts.bodyPartsHeadlineLabel.text", comment: "")
        
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            bodyPartsHeadlineLabel.font = UIFont(name: "Teko-Bold", size: 20.0)
        }
        
        
        
        
        // Messages Table View
        bodyPartsTableView.delegate = self
        bodyPartsTableView.dataSource = self
        
        bodyPartsTableView.backgroundColor = UIColor.clear
        bodyPartsTableView.separatorStyle = .none
        
        // Constraints
        self.view.addSubview(bodyPartsTableView)
        bodyPartsTableView.translatesAutoresizingMaskIntoConstraints = false
        bodyPartsTableView.topAnchor.constraint(equalTo: self.bodyPartsHeadlineLabel.bottomAnchor, constant: 0.0).isActive = true
        bodyPartsTableView.bottomAnchor.constraint(equalTo: self.addCustomBodyPartButton.topAnchor, constant: 10.0).isActive = true
        bodyPartsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        bodyPartsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        
        // Register Cells
        // Messages Table View
        bodyPartsTableView.register(SlsGameSelectBodyPartsTableViewCells.self, forCellReuseIdentifier: bodyPartsTableViewCellId)
        
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        self.bodyPartsTableView.contentInset = insets
        
        
        
        
        
        self.view.addSubview(addCustomActionsButton)
        addCustomActionsButton.translatesAutoresizingMaskIntoConstraints = false
        addCustomActionsButton.bottomAnchor.constraint(equalTo: self.bodyPartsHeadlineLabel.topAnchor, constant: -15.0).isActive = true
        addCustomActionsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            addCustomActionsButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        } else {
            addCustomActionsButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        }
        addCustomActionsButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        addCustomActionsButton.addTarget(self, action: #selector(addCustomActionsButtonAction), for: .touchUpInside)
        
        // Button Animation
        addCustomActionsButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        addCustomActionsButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        addCustomActionsButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        
        
        
        self.view.addSubview(actionsHeadlineLabel)
        actionsHeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        actionsHeadlineLabel.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 7.0).isActive = true
        actionsHeadlineLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        actionsHeadlineLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        
        actionsHeadlineLabel.text = NSLocalizedString("DiceToSpiceGameSelectBodyParts.actionsHeadlineLabel.text", comment: "")
        
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            actionsHeadlineLabel.font = UIFont(name: "Teko-Bold", size: 20.0)
        }
        
        
        
        
        // Messages Table View
        actionsTableView.delegate = self
        actionsTableView.dataSource = self
        
        actionsTableView.backgroundColor = UIColor.clear
        actionsTableView.separatorStyle = .none
        
        // Constraints
        self.view.addSubview(actionsTableView)
        actionsTableView.translatesAutoresizingMaskIntoConstraints = false
        actionsTableView.topAnchor.constraint(equalTo: self.actionsHeadlineLabel.bottomAnchor, constant: 0.0).isActive = true
        actionsTableView.bottomAnchor.constraint(equalTo: self.addCustomActionsButton.topAnchor, constant: 10.0).isActive = true
        actionsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        actionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        
        // Register Cells
        // Messages Table View
        actionsTableView.register(SlsGameSelectBodyPartsTableViewCells.self, forCellReuseIdentifier: actionsTableViewCellId)
        
        self.actionsTableView.contentInset = insets
        
        
        self.view.bringSubviewToFront(addCustomActionsButton)
        self.view.bringSubviewToFront(addCustomBodyPartButton)
        
    }
    
    
    @objc func closeButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        if self.selectedActions.count >= 2 && self.selectedBodyParts.count >= 2 {
            
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name("UpdatePickerViewLevelNotification"), object: self)
            }
            
        } else {
            
            // Alert
            let alert = UIAlertController(title: NSLocalizedString("DiceToSpiceGameSelectBodyParts.alertMinimumSelectedBodyPartsAndActions.title", comment: ""), message: nil, preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "OK", style: .default) { (action) in
                
                
                
            }
            
            let action2 = UIAlertAction(title: NSLocalizedString("UIAlertController.laterButton", comment: ""), style: .cancel) { (action) in
                
                self.selectedActions.removeAll()
                self.selectedBodyParts.removeAll()
                self.customActions.removeAll()
                self.customBodyParts.removeAll()
                
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(self.selectedActions, forKey: "selectedActionsDiceGame")
                userDefaults.setValue(self.selectedBodyParts, forKey: "selectedBodyPartsDiceGame")
                userDefaults.setValue(self.customActions, forKey: "customActionsDiceGame")
                userDefaults.setValue(self.customBodyParts, forKey: "customBodyPartsDiceGame")
                
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: Notification.Name("UpdatePickerViewLevelNotification"), object: self)
                }
                
            }
            
            alert.addAction(action1)
            alert.addAction(action2)
            alert.view.tintColor = appColor
            self.present(alert, animated: true)
            
        }
        
    }
    
    
    @objc func addCustomBodyPartButtonAction() {
        
        // Declare Alert message
        let dialogMessage = UIAlertController(title: NSLocalizedString("DiceToSpiceGameSelectBodyParts.addCustomBodyPartButton.alertDialog.title", comment: ""), message: NSLocalizedString("DiceToSpiceGameSelectBodyParts.addCustomBodyPartButton.alertDialog.message", comment: ""), preferredStyle: .alert)
        dialogMessage.view.tintColor = appColor
        
        // Add text field
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = NSLocalizedString("DiceToSpiceGameSelectBodyParts.addCustomBodyPartButton.alertDialog.placeholder", comment: "")
        })
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            let newBodyPart = dialogMessage.textFields?.first?.text ?? ""
            print("New Body Part = \(newBodyPart)")
            
            if !self.customBodyParts.contains(newBodyPart) {
                
                self.customBodyParts.append(newBodyPart)
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.customBodyParts, forKey: "customBodyPartsDiceGame")
                
                self.bodyPartsTableView.reloadData()
                self.bodyPartsTableView.scrollToRow(at: IndexPath(row: 24 + self.customBodyParts.count - 1, section: 0), at: .bottom, animated: true)
                
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
        
        
    }
    
    
    @objc func addCustomActionsButtonAction() {
        
        // Declare Alert message
        let dialogMessage = UIAlertController(title: NSLocalizedString("DiceToSpiceGameSelectBodyParts.addCustomActionsButton.alertDialog.title", comment: ""), message: NSLocalizedString("DiceToSpiceGameSelectBodyParts.addCustomActionsButton.alertDialog.message", comment: ""), preferredStyle: .alert)
        dialogMessage.view.tintColor = appColor
        
        // Add text field
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = NSLocalizedString("DiceToSpiceGameSelectBodyParts.addCustomActionsButton.alertDialog.placeholder", comment: "")
        })
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            let newBodyPart = dialogMessage.textFields?.first?.text ?? ""
            print("New Action = \(newBodyPart)")
            
            if !self.customActions.contains(newBodyPart) {
                
                self.customActions.append(newBodyPart)
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.customActions, forKey: "customActionsDiceGame")
                
                self.actionsTableView.reloadData()
                self.actionsTableView.scrollToRow(at: IndexPath(row: 10 + self.customActions.count - 1, section: 0), at: .bottom, animated: true)
                
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
        
        
    }
    
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        
        sender.touchDownAnimation {}
        
    }
    
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        
        sender.touchUpAnimation {}
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.actionsTableView {
            return 10 + self.customActions.count
        }
        
        return 24 + self.customBodyParts.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 62.0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.actionsTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: actionsTableViewCellId, for: indexPath) as! SlsGameSelectBodyPartsTableViewCells
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.clipsToBounds = false
            cell.headlineLabel.text = NSLocalizedString("DiceToSpiceGameMenu.actionTasks.\(indexPath.row+1)", comment: "")
            
            if self.selectedActions.contains(indexPath.row+1) {
                cell.checkButton.setImage(UIImage(named: "DiceDifficultySelected"), for: .normal)
                cell.checkButton.backgroundColor = UIColor(red: 0.7725, green: 0.7725, blue: 0.9373, alpha: 1.0) /* #c5c5ef */
            } else {
                cell.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
                cell.checkButton.backgroundColor = UIColor.white
            }
            
            if indexPath.row > 9 {
                cell.headlineLabel.text = self.customActions[indexPath.row-10]
            }
            
            return cell
            
        }
        
        // else
        
        let cell = tableView.dequeueReusableCell(withIdentifier: bodyPartsTableViewCellId, for: indexPath) as! SlsGameSelectBodyPartsTableViewCells
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.clipsToBounds = false
        cell.headlineLabel.text = NSLocalizedString("SqueezLickSuckGame.challenges.\(indexPath.row+1)", comment: "")
        
        if self.selectedBodyParts.contains(indexPath.row+1) {
            cell.checkButton.setImage(UIImage(named: "DiceDifficultySelected"), for: .normal)
            cell.checkButton.backgroundColor = UIColor(red: 0.7725, green: 0.7725, blue: 0.9373, alpha: 1.0) /* #c5c5ef */
        } else {
            cell.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            cell.checkButton.backgroundColor = UIColor.white
        }
        
        if indexPath.row > 23 {
            cell.headlineLabel.text = self.customBodyParts[indexPath.row-24]
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.actionsTableView {
            
            if !self.selectedActions.contains(indexPath.row+1) {
                
                // Success
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                self.selectedActions.append(indexPath.row+1)
                
            } else {
                
                // Error
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                
                let index = self.selectedActions.firstIndex(of: indexPath.row+1)!
                self.selectedActions.remove(at: index)
                
            }
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(self.selectedActions, forKey: "selectedActionsDiceGame")
            
            
            self.actionsTableView.reloadData()
            
            return
            
        }
        
        
        if !self.selectedBodyParts.contains(indexPath.row+1) {
            
            // Success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            self.selectedBodyParts.append(indexPath.row+1)
            
        } else {
            
            // Error
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            let index = self.selectedBodyParts.firstIndex(of: indexPath.row+1)!
            self.selectedBodyParts.remove(at: index)
            
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(self.selectedBodyParts, forKey: "selectedBodyPartsDiceGame")
        
        
        self.bodyPartsTableView.reloadData()
        
    }
    
}
