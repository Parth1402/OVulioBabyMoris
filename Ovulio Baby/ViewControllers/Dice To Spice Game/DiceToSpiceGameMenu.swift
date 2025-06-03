//
//  DiceToSpiceGameMenu.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 07.08.22.
//

import UIKit
import Device
import GlowingView
import ViewAnimator
import SwiftyStoreKit
import SPConfetti
import SPAlert


class DiceToSpiceGameMenu: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let backgroundShapeImageView: UIImageView = {
        
        let imageViewBackgroundShape = UIImageView()
        imageViewBackgroundShape.backgroundColor = UIColor.clear
        imageViewBackgroundShape.contentMode = .scaleAspectFill
        imageViewBackgroundShape.image = UIImage(named: "Scratch Adventure Background Image.jpg")
        imageViewBackgroundShape.clipsToBounds = true
        
        return imageViewBackgroundShape
        
    }()
    
    
    let backgroundSalesPageImageView: UIImageView = {
        
        let imageViewBackgroundShape = UIImageView()
        imageViewBackgroundShape.backgroundColor = UIColor.clear
        imageViewBackgroundShape.contentMode = .scaleAspectFill
        imageViewBackgroundShape.image = UIImage(named: "SLS Game Background Sales Section.jpg")
        imageViewBackgroundShape.clipsToBounds = true
        
        return imageViewBackgroundShape
        
    }()
    
    
    let headlineLabelBold: UILabel = {
        
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.font = .boldSystemFont(ofSize: 24.pulse2Font())
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .center
        labelHeadline.adjustsFontSizeToFitWidth = true
        labelHeadline.numberOfLines = 3
        
        return labelHeadline
        
    }()
    
    
    let headlineLabel: UILabel = {
        
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.font = .boldSystemFont(ofSize: 24.pulse2Font())
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .center
        labelHeadline.adjustsFontSizeToFitWidth = true
        labelHeadline.numberOfLines = 2
        
        return labelHeadline
        
    }()
    
    
    let underlineShapeImageView: UIImageView = {
        
        let imageViewBackgroundShape = UIImageView()
        imageViewBackgroundShape.backgroundColor = UIColor.clear
        imageViewBackgroundShape.contentMode = .scaleToFill
        imageViewBackgroundShape.image = UIImage(named: "Rules Menu Underline Shape")
        
        return imageViewBackgroundShape
        
    }()
    
    let backButton: UIButton = {
        
        let buttonClose = UIButton()
        buttonClose.contentMode = .scaleAspectFit
        buttonClose.setImage(UIImage(named: "backButtonImg"), for: .normal)
        
        return buttonClose
        
    }()
    
    let editCustomGameButton: UIButton = {
        
        let buttonClose = UIButton()
        buttonClose.contentMode = .scaleAspectFit
        buttonClose.setImage(UIImage(named: "editDiceOptionsButton"), for: .normal)
        
        return buttonClose
        
    }()
    
    
    let gameSettingsView = DiceToSpiceGameGameSettingsView()
    
    let enterPlayerNameView = EnterPlayerNameView()
    
    
    var pickerViewBackgroundView = UIView()
    var pickerView1: UIPickerView = UIPickerView()
    var pickerView2: UIPickerView = UIPickerView()
    
    var actionTasksChallenges: [String] = []
    var bodyPartsChallenges: [String] = []
    
    var pickerTimer = Timer()
    var pickerViewMoves: Int = 0
    
    let arrowIconImageView1: UIImageView = {
        
        let imageViewIcon = UIImageView()
        imageViewIcon.contentMode = .scaleAspectFit
        imageViewIcon.image = UIImage(named: "DiceSpinErrorImg")
        
        return imageViewIcon
        
    }()
    
    let arrowIconImageView2: UIImageView = {
        let imageViewIcon = UIImageView()
        imageViewIcon.backgroundColor = UIColor.clear
        imageViewIcon.contentMode = .scaleAspectFit
        imageViewIcon.image = UIImage(named: "DiceSpinErrorImg")
        
        return imageViewIcon
    }()
    
    
    var position1 = 0
    var position2 = 0
    
    var sexuality: Int = 0  // 0 = straight, 1 = lesbian, 2 = gay, 3 = threesome MFF, 4 = threesome MMF, 3 and 4 not used here
    
    var level: Int = 0  // 0 = beginner, 1 = dirty, 2 = custom
    
    
    var player1Name: String = ""
    var player2Name: String = ""
    
    var previousSelectedPlayer: Int = 5  // do not set to 0 or 1 here so that we have a fresh start in the game, any number than 0 or 1
    var previousSelectedPlayerCount: Int = 0
    
    var currentPlayer: Player = .player1
    
    var movePickerAgainCount: Int = 0
    
    
    let hintLabelNoCustomDiceTasks: UILabel = {
        
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.font = UIFont(name: "Poppins-BoldItalic", size: 20.0)
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .center
        labelHeadline.adjustsFontSizeToFitWidth = true
        labelHeadline.numberOfLines = 0
        
        return labelHeadline
        
    }()
    
    
    let hintButtonNoCustomDiceTasks: UIButton = {
        
        let buttonUnlockNow = UIButton()
        buttonUnlockNow.backgroundColor = UIColor.white
        buttonUnlockNow.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 18.0)
        buttonUnlockNow.setTitleColor(appColor, for: .normal)
        buttonUnlockNow.setTitle(NSLocalizedString("DiceToSpiceGameSelectBodyParts.hintButtonNoCustomDiceTasks.text", comment: ""), for: .normal)
        buttonUnlockNow.layer.cornerRadius = 10.0
        
        return buttonUnlockNow
        
    }()
    
    
    var isIapMenuOpen: Bool = false
    
    
    var numberOfSpins: Int = 0  // after 4 spins, another 10 spins and another 14 spins show Dice Short Sales Page
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        backgroundShapeImageView.image = UIImage(named: "homeScreenBackground")
        backgroundShapeImageView.alpha = 1.0
        
        self.view.addSubview(backgroundShapeImageView)
        backgroundShapeImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundShapeImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        backgroundShapeImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        backgroundShapeImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        backgroundShapeImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        //backgroundShapeImageView.alpha = 0.4
        
        
        
        
        
        self.view.addSubview(backgroundSalesPageImageView)
        backgroundSalesPageImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundSalesPageImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        backgroundSalesPageImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        backgroundSalesPageImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        backgroundSalesPageImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        
        backgroundSalesPageImageView.alpha = 0.6
        backgroundSalesPageImageView.isHidden = true
        
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        
        
        backButton.addTarget(self, action: #selector(backButtonButtonAction), for: .touchUpInside)
        
        // Button Animation
        backButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        backButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchDragOutside)
        
        
        self.view.addSubview(headlineLabelBold)
        headlineLabelBold.translatesAutoresizingMaskIntoConstraints = false
        headlineLabelBold.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        headlineLabelBold.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        headlineLabelBold.leftAnchor.constraint(equalTo: self.backButton.rightAnchor, constant: 15).isActive = true
        headlineLabelBold.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30.0).isActive = true
        
        headlineLabelBold.text = NSLocalizedString("DiceToSpiceGameMenu.headlineLabelBold.text", comment: "")
        
//        if Device.size() <= Size.screen4_7Inch {
//            // Device is iPhone 6s or smaller
//            headlineLabelBold.font = UIFont(name: "Teko-Bold", size: 28.0)
//        }
//        headlineLabelBold.sizeToFit()
//        headlineLabelBold.clipsToBounds = false
//        headlineLabelBold.setLineHeight(lineHeight: 0.6)
        
        
        
        
        
        self.view.addSubview(headlineLabel)
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
        headlineLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30.0).isActive = true
        headlineLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30.0).isActive = true
        headlineLabel.text = NSLocalizedString("DiceToSpiceGameMenu.headlineLabel.text", comment: "")
        
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            headlineLabel.font = .boldSystemFont(ofSize: 24.pulse2Font())
        }
        
        headlineLabel.sizeToFit()
        headlineLabel.alpha = 0.0
        
//        backButton.centerYAnchor.constraint(equalTo: self.headlineLabelBold.centerYAnchor).isActive = true
        
        
        
        var underlineShapeImageViewWidth = headlineLabel.frame.size.width + 16.0
        if underlineShapeImageViewWidth < UIScreen.main.bounds.width {
            // Everything ok
        } else {
            underlineShapeImageViewWidth = UIScreen.main.bounds.width * 0.8
        }
        let underlineShapeImageViewHeight = ((65.0 / 1004.0) * underlineShapeImageViewWidth) * 0.6
        
        self.view.addSubview(underlineShapeImageView)
        underlineShapeImageView.translatesAutoresizingMaskIntoConstraints = false
        underlineShapeImageView.topAnchor.constraint(equalTo: self.headlineLabel.bottomAnchor, constant: -12.0).isActive = true
        underlineShapeImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        underlineShapeImageView.widthAnchor.constraint(equalToConstant: underlineShapeImageViewWidth).isActive = true
        underlineShapeImageView.heightAnchor.constraint(equalToConstant: underlineShapeImageViewHeight).isActive = true
        
        self.view.bringSubviewToFront(headlineLabel)
        underlineShapeImageView.alpha = 0.0
        
        
        
        
        
        
        
        self.view.addSubview(editCustomGameButton)
        editCustomGameButton.isHidden = true
        editCustomGameButton.translatesAutoresizingMaskIntoConstraints = false
        editCustomGameButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0).isActive = true
        editCustomGameButton.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        editCustomGameButton.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        editCustomGameButton.centerYAnchor.constraint(equalTo: self.headlineLabel.centerYAnchor).isActive = true
        
        editCustomGameButton.addTarget(self, action: #selector(editCustomDiceGameButtonAction), for: .touchUpInside)
        
        // Button Animation
        editCustomGameButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        editCustomGameButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchDragOutside)
        
        
        
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        
        self.view.addSubview(gameSettingsView)
        gameSettingsView.translatesAutoresizingMaskIntoConstraints = false
        gameSettingsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        gameSettingsView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        gameSettingsView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        gameSettingsView.heightAnchor.constraint(equalToConstant: bottomPadding! + 240.0).isActive = true
        
        gameSettingsView.updateButtons()
        
        gameSettingsView.diceButton.addTarget(self, action: #selector(diceButtonAction), for: .touchUpInside)
        
        
        gameSettingsView.cuteButton.checkButton.addTarget(self, action: #selector(cuteButtonAction), for: .touchUpInside)
        gameSettingsView.spicyButton.checkButton.addTarget(self, action: #selector(spicyButtonAction), for: .touchUpInside)
        gameSettingsView.customButton.checkButton.addTarget(self, action: #selector(customButtonAction), for: .touchUpInside)
        
        
        
        
        
        
        self.view.addSubview(enterPlayerNameView)
        enterPlayerNameView.translatesAutoresizingMaskIntoConstraints = false
        //enterPlayerNameView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100.0).isActive = true
        enterPlayerNameView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        enterPlayerNameView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        //enterPlayerNameView.heightAnchor.constraint(equalToConstant: 460.0).isActive = true
        enterPlayerNameView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        enterPlayerNameView.topAnchor.constraint(equalTo: self.headlineLabelBold.bottomAnchor, constant: 0.0).isActive = true
        
        enterPlayerNameView.letsGoButton.addTarget(self, action: #selector(enterPlayerLetsGoButtonAction), for: .touchUpInside)
        
        enterPlayerNameView.player1TextField.delegate = self
        enterPlayerNameView.player2TextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
        
//        enterPlayerNameView.levelBeginnerButton.isHidden = true
//        enterPlayerNameView.levelDirtyButton.isHidden = true
//        enterPlayerNameView.levelCustomButton.isHidden = true
//        enterPlayerNameView.levelSelectionBackgroundView.isHidden = true
        enterPlayerNameView.levelHeadlineLabel.isHidden = true
        
        
        
        
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "sexuality") != nil {
            
            self.sexuality = userDefaults.value(forKey: "sexuality") as! Int
            if self.sexuality > 2 {
                self.sexuality = 0  // Set Straight as Default
            }
            
        }
        
        if userDefaults.value(forKey: "sexualitySlsGame") != nil {
            self.sexuality = userDefaults.value(forKey: "sexualitySlsGame") as! Int
        }
        
        if sexuality == 0 {
            enterPlayerNameView.selectedSexuality = .straight
        } else if sexuality == 1 {
            enterPlayerNameView.selectedSexuality = .lesbian
        } else if sexuality == 2 {
            enterPlayerNameView.selectedSexuality = .gay
        }
        
//        enterPlayerNameView.updateButtons()
        
        self.updateLevelButton()
        
        
        
        // Get Players Name
        if userDefaults.value(forKey: "MotherName") != nil {
            enterPlayerNameView.player1TextField.text = userDefaults.value(forKey: "MotherName") as! String
        }
        
        if userDefaults.value(forKey: "FatherName") != nil {
            enterPlayerNameView.player2TextField.text = userDefaults.value(forKey: "FatherName") as! String
        }
        
        
        
        
        
        pickerViewBackgroundView.backgroundColor = UIColor.clear
        self.view.addSubview(pickerViewBackgroundView)
        pickerViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        pickerViewBackgroundView.topAnchor.constraint(equalTo: underlineShapeImageView.bottomAnchor, constant: 0.0).isActive = true
        pickerViewBackgroundView.bottomAnchor.constraint(equalTo: gameSettingsView.topAnchor, constant: 0.0).isActive = true
        pickerViewBackgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        pickerViewBackgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        
        
        
        
        
        self.view.addSubview(pickerView1)
        pickerView1.translatesAutoresizingMaskIntoConstraints = false
        //pickerView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 160.0).isActive = true
        pickerView1.bottomAnchor.constraint(equalTo: self.pickerViewBackgroundView.centerYAnchor, constant: -12.0).isActive = true
        pickerView1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            pickerView1.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4).isActive = true
            pickerView1.heightAnchor.constraint(equalToConstant: 260.0).isActive = true
        } else {
            pickerView1.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
            pickerView1.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        }
        
        //pickerView.sizeToFit()
        
        pickerView1.backgroundColor = UIColor.clear
        /*
        pickerView.datePickerMode = .date
        if #available(iOS 13.4, *) {
            pickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        */
        
//        pickerView1.setValue(UIColor.black, forKey: "textColor")
        //pickerView.setValue(false, forKey: "highlightsToday")
        
        pickerView1.isUserInteractionEnabled = false
        pickerView1.delegate = self
        pickerView1.dataSource = self
        
        
        
        
        
        self.view.addSubview(pickerView2)
        pickerView2.translatesAutoresizingMaskIntoConstraints = false
        pickerView2.topAnchor.constraint(equalTo: self.pickerViewBackgroundView.centerYAnchor, constant: 12.0).isActive = true
        pickerView2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            pickerView2.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4).isActive = true
            pickerView2.heightAnchor.constraint(equalToConstant: 260.0).isActive = true
        } else {
            pickerView2.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
            pickerView2.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        }
        
        pickerView2.backgroundColor = UIColor.clear
        /*
        pickerView.datePickerMode = .date
        if #available(iOS 13.4, *) {
            pickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        */
        
        pickerView2.setValue(UIColor.black, forKey: "textColor")
        //pickerView2.setValue(false, forKey: "highlightsToday")
        
        pickerView2.isUserInteractionEnabled = false
        pickerView2.delegate = self
        pickerView2.dataSource = self
        
        //self.updatePickerViewLevel()
        
        
        
        
        
        self.view.addSubview(arrowIconImageView1)
        arrowIconImageView1.translatesAutoresizingMaskIntoConstraints = false
        //arrowIconImageView1.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 160.0).isActive = true
        arrowIconImageView1.leftAnchor.constraint(equalTo: self.pickerView1.rightAnchor, constant: 5).isActive = true
        arrowIconImageView1.centerYAnchor.constraint(equalTo: self.pickerView1.centerYAnchor, constant: 0.0).isActive = true
        arrowIconImageView1.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        arrowIconImageView1.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        
        
        
        
        
        self.view.addSubview(arrowIconImageView2)
        arrowIconImageView2.translatesAutoresizingMaskIntoConstraints = false
        //arrowIconImageView2.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 160.0).isActive = true
        arrowIconImageView2.leftAnchor.constraint(equalTo: self.pickerView2.rightAnchor, constant: 5).isActive = true
        arrowIconImageView2.centerYAnchor.constraint(equalTo: self.pickerView2.centerYAnchor, constant: 0.0).isActive = true
        arrowIconImageView2.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        arrowIconImageView2.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        
        
        
        
        
        self.view.addSubview(hintLabelNoCustomDiceTasks)
        hintLabelNoCustomDiceTasks.translatesAutoresizingMaskIntoConstraints = false
        hintLabelNoCustomDiceTasks.bottomAnchor.constraint(equalTo: pickerView1.bottomAnchor, constant: 0.0).isActive = true
        hintLabelNoCustomDiceTasks.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            hintLabelNoCustomDiceTasks.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5).isActive = true
        } else {
            hintLabelNoCustomDiceTasks.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
        }
        
        hintLabelNoCustomDiceTasks.text = NSLocalizedString("DiceToSpiceGameSelectBodyParts.hintLabelNoCustomDiceTasks.text", comment: "")
        hintLabelNoCustomDiceTasks.isHidden = true
        
        
        
        
        
        self.view.addSubview(hintButtonNoCustomDiceTasks)
        hintButtonNoCustomDiceTasks.translatesAutoresizingMaskIntoConstraints = false
        hintButtonNoCustomDiceTasks.topAnchor.constraint(equalTo: self.hintLabelNoCustomDiceTasks.bottomAnchor, constant: 10.0).isActive = true
        hintButtonNoCustomDiceTasks.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        hintButtonNoCustomDiceTasks.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            hintButtonNoCustomDiceTasks.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.35).isActive = true
        } else {
            hintButtonNoCustomDiceTasks.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5).isActive = true
        }
        
        hintButtonNoCustomDiceTasks.addTarget(self, action: #selector(editCustomDiceGameButtonAction), for: .touchUpInside)
        
        // Button Animation
        hintButtonNoCustomDiceTasks.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        hintButtonNoCustomDiceTasks.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        hintButtonNoCustomDiceTasks.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        hintButtonNoCustomDiceTasks.isHidden = true
        
        
        
        
        
        pickerView1.isHidden = true
        pickerView2.isHidden = true
        arrowIconImageView1.isHidden = true
        arrowIconImageView2.isHidden = true
        gameSettingsView.isHidden = true
        
        
        
        
        
        self.view.bringSubviewToFront(self.underlineShapeImageView)
        self.view.bringSubviewToFront(self.headlineLabel)
        
        self.view.bringSubviewToFront(self.enterPlayerNameView)
        self.view.bringSubviewToFront(self.editCustomGameButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePickerViewLevel), name: Notification.Name("UpdatePickerViewLevelNotification"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.updatePickerViewLevel()
        
        if self.isIapMenuOpen == true {
            
            self.isIapMenuOpen = false
            self.backToPreviousVersionButtonAction()
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    
    @objc func backButtonButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.dismiss(animated: true)
        
    }
    
    
    @objc func editCustomDiceGameButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Check if Pro Member, else show Sales Page
        if isUserProMember() {
            
            // PRO Users
            DispatchQueue.main.async {
                
                let destinationViewController = DiceToSpiceGameSelectBodyParts()
                if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
                    destinationViewController.modalPresentationStyle = .fullScreen
                } else {
                    destinationViewController.modalPresentationStyle = .formSheet
                }
                if #available(iOS 13.0, *) {
                    destinationViewController.isModalInPresentation = true
                } else {
                    // Fallback on earlier versions
                }
                self.present(destinationViewController, animated: true, completion: nil)
                
            }
            
        } else {
            
            self.makeSalesPageVisible()
            
        }
        
    }
    
    
    @objc func updatePickerViewLevel() {
        
        self.actionTasksChallenges.removeAll()
        self.bodyPartsChallenges.removeAll()
        
        self.pickerView1.alpha = 1.0
        self.pickerView2.alpha = 1.0
        self.arrowIconImageView1.alpha = 1.0
        self.arrowIconImageView2.alpha = 1.0
        self.hintLabelNoCustomDiceTasks.isHidden = true
        self.hintButtonNoCustomDiceTasks.isHidden = true
        
        if self.gameSettingsView.selectedCategory == .cute {
            
            for j in 0...9 {
                
                for i in 1...27 {
                    
                    let includedBodyParts: [Int] = [1, 9, 10, 11, 13, 14, 16, 17, 18, 20, 21, 22, 23, 25]
                    if includedBodyParts.contains(i) {
                        let localizedStringId = "SqueezLickSuckGame.challenges." + String(i)
                        bodyPartsChallenges.append(NSLocalizedString(localizedStringId, comment: ""))
                    }
                    
                }
                
                for i in 1...10 {
                    
                    let includedActionTasks: [Int] = [1, 2, 4, 5, 6, 7, 8]
                    if includedActionTasks.contains(i) {
                        let localizedStringId = "DiceToSpiceGameMenu.actionTasks." + String(i)
                        actionTasksChallenges.append(NSLocalizedString(localizedStringId, comment: ""))
                    }
                    
                }
                
            }
            
            
            self.pickerView1.reloadComponent(0)
            self.pickerView1.selectRow(2, inComponent: 0, animated: false)
            self.pickerView1.showsSelectionIndicator = true
            
            self.pickerView2.reloadComponent(0)
            self.pickerView2.selectRow(2, inComponent: 0, animated: false)
            self.pickerView2.showsSelectionIndicator = true
            
        } else if self.gameSettingsView.selectedCategory == .spicy {
            
            for j in 0...9 {
                
                for i in 1...27 {
                    
                    let includedBodyParts: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 20, 21, 24, 26, 27]
                    if includedBodyParts.contains(i) {
                        let localizedStringId = "SqueezLickSuckGame.challenges." + String(i)
                        bodyPartsChallenges.append(NSLocalizedString(localizedStringId, comment: ""))
                    }
                    
                }
                
                for i in 1...10 {
                    
                    let includedActionTasks: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
                    if includedActionTasks.contains(i) {
                        let localizedStringId = "DiceToSpiceGameMenu.actionTasks." + String(i)
                        actionTasksChallenges.append(NSLocalizedString(localizedStringId, comment: ""))
                    }
                    
                }
                
            }
            
            
            self.pickerView1.reloadComponent(0)
            self.pickerView1.selectRow(8, inComponent: 0, animated: false)
            self.pickerView1.showsSelectionIndicator = true
            
            self.pickerView2.reloadComponent(0)
            self.pickerView2.selectRow(8, inComponent: 0, animated: false)
            self.pickerView2.showsSelectionIndicator = true
            
        } else if self.gameSettingsView.selectedCategory == .custom {
            
            var selectedBodyParts: [Int] = []
            var customBodyParts: [String] = []
            
            var selectedActions: [Int] = []
            var customActions: [String] = []
            
            // User Defaults
            let userDefaults = UserDefaults.standard
            if userDefaults.value(forKey: "selectedBodyPartsDiceGame") != nil {
                selectedBodyParts = userDefaults.value(forKey: "selectedBodyPartsDiceGame") as! [Int]
            }
            
            if userDefaults.value(forKey: "customBodyPartsDiceGame") != nil {
                customBodyParts = userDefaults.value(forKey: "customBodyPartsDiceGame") as! [String]
            }
            
            if userDefaults.value(forKey: "selectedActionsDiceGame") != nil {
                selectedActions = userDefaults.value(forKey: "selectedActionsDiceGame") as! [Int]
            }
            
            if userDefaults.value(forKey: "customActionsDiceGame") != nil {
                customActions = userDefaults.value(forKey: "customActionsDiceGame") as! [String]
            }
            
            
            for j in 0...9 {
                
                for i in 0...(23 + customBodyParts.count) {
                    
                    if selectedBodyParts.contains(i+1) {
                        
                        if i > 23 {
                            
                            bodyPartsChallenges.append(customBodyParts[i-24])
                            
                        } else {
                            
                            let localizedStringId = "SqueezLickSuckGame.challenges." + String(i+1)
                            bodyPartsChallenges.append(NSLocalizedString(localizedStringId, comment: ""))
                            
                        }
                        
                    }
                    
                }
                
                
                for i in 0...(9 + customActions.count) {
                    
                    if selectedActions.contains(i+1) {
                        
                        if i > 9 {
                            
                            actionTasksChallenges.append(customActions[i-10])
                            
                        } else {
                            
                            let localizedStringId = "DiceToSpiceGameMenu.actionTasks." + String(i+1)
                            actionTasksChallenges.append(NSLocalizedString(localizedStringId, comment: ""))
                            
                        }
                        
                    }
                    
                }
                
            }
            
            if self.bodyPartsChallenges.count != 0 {
                
                self.pickerView1.reloadComponent(0)
                self.pickerView1.selectRow(4, inComponent: 0, animated: false)
                self.pickerView1.showsSelectionIndicator = true
                
                self.pickerView2.reloadComponent(0)
                self.pickerView2.selectRow(4, inComponent: 0, animated: false)
                self.pickerView2.showsSelectionIndicator = true
                
            } else {
                
                // Give Hint that no body parts and actions are selected
                self.hintLabelNoCustomDiceTasks.isHidden = false
                self.hintButtonNoCustomDiceTasks.isHidden = false
                
                for j in 0...9 {
                    for i in 0...23 {
                        let localizedStringId = "SqueezLickSuckGame.challenges." + String(i+1)
                        bodyPartsChallenges.append(NSLocalizedString(localizedStringId, comment: ""))
                        print(i)
                    }
                    
                    for i in 0...9 {
                        let localizedStringId = "DiceToSpiceGameMenu.actionTasks." + String(i+1)
                        actionTasksChallenges.append(NSLocalizedString(localizedStringId, comment: ""))
                        print(i)
                    }
                }
                
                self.pickerView1.reloadComponent(0)
                self.pickerView1.selectRow(8, inComponent: 0, animated: false)
                self.pickerView1.showsSelectionIndicator = true
                
                self.pickerView2.reloadComponent(0)
                self.pickerView2.selectRow(8, inComponent: 0, animated: false)
                self.pickerView2.showsSelectionIndicator = true
                
                self.pickerView1.alpha = 0.15
                self.pickerView2.alpha = 0.15
                self.arrowIconImageView1.alpha = 0.15
                self.arrowIconImageView2.alpha = 0.15
                
            }
            
        }
        
    }
    
    
    
    @objc func cuteButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.editCustomGameButton.isHidden = true
        self.updatePickerViewLevel()
        
    }
    
    
    @objc func spicyButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.editCustomGameButton.isHidden = true
        self.updatePickerViewLevel()
        
    }
    
    
    @objc func customButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.editCustomGameButton.isHidden = false
        self.updatePickerViewLevel()
        
    }
    
    
    func alertWithTitle(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = appColor
        alert.addAction(UIAlertAction(title: NSLocalizedString("UIAlertController.okButton", comment: ""), style: .cancel, handler: nil))
        
        return alert
        
    }
    
    
    func showAlert(alert: UIAlertController?) {
        
        guard let _ = self.presentedViewController else {
            
            if alert != nil {
                self.present(alert!, animated: true, completion: nil)
            }
            
            return
            
        }
        
    }
    
    
    func alertForPurchaseResult(result: PurchaseResult) -> UIAlertController? {
        
        /*
        case .success(let product):
            print("Purchase successful: \(product.productId)")
            return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.success.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.success.message", comment: ""))
        */
        
        switch result {
        case .success(purchase: let purchase):
            return nil
        case .error(let error):
            print("Purchase failed: \(error)")
            
            switch error.code {
            case .unknown: return alertWithTitle(title: "Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.clientInvalid.message", comment: ""))
            //case .paymentCancelled: // user cancelled the request, etc.
                //return
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.paymentInvalid.message", comment: ""))
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.paymentNotAllowed.message", comment: ""))
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.storeProductNotAvailable.message", comment: ""))
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.cloudServicePermissionDenied.message", comment: ""))
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.cloudServiceNetworkConnectionFailed.message", comment: ""))
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.cloudServiceRevoked.message", comment: ""))
            default:
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchaseOfferMenu.alert.uploadError.title", comment: ""))
                //return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: (error as NSError).localizedDescription)
            }
            
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
    
    
    func updateLevelButton() {
        /*
        var levelButtonString = NSLocalizedString("SqueezLickSuckGame.levelButton.title", comment: "")
        if selectedSlsLevel == .Beginner {
            levelButtonString += NSLocalizedString("SqueezLickSuckGame.levelButton.level.1", comment: "")
            self.editCustomSlsGameButton.isHidden = true
        } else if selectedSlsLevel == .Dirty {
            levelButtonString += NSLocalizedString("SqueezLickSuckGame.levelButton.level.2", comment: "")
            self.editCustomSlsGameButton.isHidden = true
        } else if selectedSlsLevel == .Custom {
            levelButtonString += NSLocalizedString("SqueezLickSuckGame.levelButton.level.3", comment: "")
            self.editCustomSlsGameButton.isHidden = false
            self.editCustomSlsGameButton.alpha = 1.0
        }
        
        self.levelButton.titleTextLabel.text = levelButtonString
        */
    }
    
    
    @objc func backToPreviousVersionButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.gameSettingsView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
            self.editCustomGameButton.alpha = 0.0
        } completion: { sucess in
            self.editCustomGameButton.isHidden = true
            self.editCustomGameButton.alpha = 1.0
        }
        
        gameSettingsView.selectedCategory = .cute
        gameSettingsView.updateButtons()
        
        self.updateLevelButton()
        self.updatePickerViewLevel()
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(0, forKey: "selectedSlsLevel")
        
        //self.makeSalesPageInvisible()
        
    }
    
    
    @objc func diceButtonAction() {
        
        print("diceButtonAction")
        self.gameSettingsView.isUserInteractionEnabled = false
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        if self.gameSettingsView.selectedCategory == .none {
            
            // Alert
            self.showAlert(title: NSLocalizedString("SqueezLickSuckGame.SqueezeLickSuckGameGameSettingsView.alertChooseCategory.title", comment: ""), message: NSLocalizedString("SqueezLickSuckGame.SqueezeLickSuckGameGameSettingsView.alertChooseCategory.message", comment: ""))
            
        } else {
            
            // Check if user is PRO Member
            if isUserProMember() {
                
                // PRO Users
                if self.gameSettingsView.selectedCategory == .custom {
                    
                    // Check if custom challenges available
                    let userDefaults = UserDefaults.standard
                    if userDefaults.value(forKey: "selectedBodyPartsDiceGame") != nil {
                        
                        let selectedBodyPartsDiceGame = userDefaults.value(forKey: "selectedBodyPartsDiceGame") as! [Int]
                        
                        if selectedBodyPartsDiceGame.count == 0 {
                            
                            // Give Alert that no body parts selected
                            self.showAlertHintNoSlsTasks()
                            
                        } else {
                            
                            self.spinPicker()
                            
                        }
                        
                    } else {
                        
                        DispatchQueue.main.async {
                            
                            let destinationViewController = DiceToSpiceGameSelectBodyParts()  //SlsGameSelectBodyParts()
                            if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
                                destinationViewController.modalPresentationStyle = .fullScreen
                            } else {
                                destinationViewController.modalPresentationStyle = .formSheet
                            }
                            if #available(iOS 13.0, *) {
                                destinationViewController.isModalInPresentation = true
                            } else {
                                // Fallback on earlier versions
                            }
                            self.present(destinationViewController, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                } else {
                    
                    self.spinPicker()
                    
                }
                
            } else {
                
                // Non PRO Users
                
                if self.gameSettingsView.selectedCategory == .cute {
                    
                    if self.numberOfSpins == 4 || self.numberOfSpins == 14 || self.numberOfSpins == 28 {
                        
                        self.numberOfSpins += 1
                        
                        self.makeSalesPageVisible()
                        
                    } else {
                        
                        // OK, let's spin
                        self.spinPicker()
                        
                    }
                    
                } else if self.gameSettingsView.selectedCategory == .spicy {
                    
                    // PRO Feature
                    self.makeSalesPageVisible()
                    
                } else if self.gameSettingsView.selectedCategory == .custom {
                    
                    self.makeSalesPageVisible()
                    
                }
                
            }
            
        }
        
    }
    
    
    func makeSalesPageVisible() {
        
        self.gameSettingsView.isUserInteractionEnabled = true
        self.isIapMenuOpen = true
        
        self.view.isHeroEnabled = true
        
        let destinationViewController = SalesVC()
        destinationViewController.modalPresentationStyle = .fullScreen
        destinationViewController.isHeroEnabled = true
        self.present(destinationViewController, animated: true, completion: nil)
        
    }
    
    
    @objc func enterPlayerLetsGoButtonAction() {
        
        print("enterPlayerLetsGoButtonAction")
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        if self.enterPlayerNameView.player1TextField.text?.count == 0 || self.enterPlayerNameView.player2TextField.text?.count == 0 {
            
            // Alert
            self.showAlert(title: NSLocalizedString("SqueezLickSuckGame.letsGoButton.userNameMissingAlert.title", comment: ""), message: NSLocalizedString("SqueezLickSuckGame.letsGoButton.userNameMissingAlert.message", comment: ""))
            
        } else {
            
            self.player1Name = self.enterPlayerNameView.player1TextField.text!
            self.player2Name = self.enterPlayerNameView.player2TextField.text!
            
            // Save Names in User Defaults
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(self.player1Name, forKey: "MotherName")
            userDefaults.setValue(self.player2Name, forKey: "FatherName")
            
            self.gameSettingsView.playerNameLabel.text = NSLocalizedString("SqueezLickSuckGame.text.turn", comment: "").replacingOccurrences(of: "%x", with: self.player1Name)
            
            /*
            self.selectedSlsLevel = self.enterPlayerNameView.selectedLevel
            self.updateLevelButton()
            self.updatePickerViewLevel()
            */
            
            // Update UI
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut) {
                self.enterPlayerNameView.alpha = 0.0
                self.headlineLabelBold.alpha = 0.0
            } completion: { success in
                self.enterPlayerNameView.isHidden = true
                self.headlineLabelBold.isHidden = true
            }
            
            
            
            self.view.bringSubviewToFront(gameSettingsView)
            
            self.gameSettingsView.alpha = 0.0
            self.gameSettingsView.isHidden = false
            
            let toAnimation = AnimationType.vector(CGVector(dx: 0, dy: 50))
            UIView.animate(views: [self.gameSettingsView],
                           animations: [toAnimation],
                           reversed: false,
                           initialAlpha: 0.0,
                           finalAlpha: 1.0,
                           delay: 0.0,
                           duration: 0.4)
            
            
            self.headlineLabel.alpha = 0.0
            self.headlineLabel.isHidden = false
            self.underlineShapeImageView.alpha = 0.0
            self.underlineShapeImageView.isHidden = false
            
            let toAnimationHeadlineLabel = AnimationType.vector(CGVector(dx: 0, dy: -50))
            UIView.animate(views: [self.headlineLabel, self.underlineShapeImageView],
                           animations: [toAnimationHeadlineLabel],
                           reversed: false,
                           initialAlpha: 0.0,
                           finalAlpha: 1.0,
                           delay: 0.0,
                           duration: 0.4)
            
            
            self.pickerView1.alpha = 0.0
            self.pickerView1.isHidden = false
            
            self.pickerView2.alpha = 0.0
            self.pickerView2.isHidden = false
            
            self.arrowIconImageView1.alpha = 0.0
            self.arrowIconImageView1.isHidden = false
            
            self.arrowIconImageView2.alpha = 0.0
            self.arrowIconImageView2.isHidden = false
            
            UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseOut) {
                self.pickerView1.alpha = 1.0
                self.pickerView2.alpha = 1.0
                self.arrowIconImageView1.alpha = 1.0
                self.arrowIconImageView2.alpha = 1.0
            } completion: { success in
                
            }
            
            
            self.updateLevelButton()
            self.updatePickerViewLevel()
            
            
            if self.gameSettingsView.selectedCategory == .custom {
                
                // Check if custom challenges available
                let userDefaults = UserDefaults.standard
                if userDefaults.value(forKey: "selectedBodyPartsDiceGame") == nil {
                    
                    // Check if Pro Member, else show Sales Page
                    if isUserProMember() {
                        
                        // PRO Users
                        DispatchQueue.main.async {
                            let destinationViewController = DiceToSpiceGameSelectBodyParts()
                            if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
                                destinationViewController.modalPresentationStyle = .fullScreen
                            } else {
                                destinationViewController.modalPresentationStyle = .formSheet
                            }
                            if #available(iOS 13.0, *) {
                                destinationViewController.isModalInPresentation = true
                            } else {
                                // Fallback on earlier versions
                            }
                            self.present(destinationViewController, animated: true, completion: nil)
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = appColor
        self.present(alert, animated: true)
        
    }
    
    
    func showAlertHintNoSlsTasks() {
        
        let alert = UIAlertController(title: NSLocalizedString("SqueezLickSuckGame.showAlertHintNoSlsTasks.alert.title", comment: ""), message: NSLocalizedString("SqueezLickSuckGame.showAlertHintNoSlsTasks.alert.message", comment: ""), preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            self.editCustomDiceGameButtonAction()
            
        }
        
        alert.addAction(action)
        alert.view.tintColor = appColor
        self.present(alert, animated: true)
        
    }
    
    
    func showAlertNoSlsTaskFound() {
        
        let alert = UIAlertController(title: NSLocalizedString("SqueezLickSuckGame.showAlertNoSlsTaskFound.alert.title", comment: ""), message: NSLocalizedString("SqueezLickSuckGame.showAlertNoSlsTaskFound.alert.message", comment: ""), preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            self.editCustomDiceGameButtonAction()
            
        }
        
        alert.addAction(action)
        alert.view.tintColor = appColor
        self.present(alert, animated: true)
        
    }
    
    
    @objc func spinPicker() {
        
        self.numberOfSpins += 1
        
        self.gameSettingsView.isUserInteractionEnabled = false
        
        self.gameSettingsView.cuteButton.isUserInteractionEnabled = false
        self.gameSettingsView.spicyButton.isUserInteractionEnabled = false
        self.gameSettingsView.customButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.4, delay: 0.0) {
            self.gameSettingsView.playerNameLabel.alpha = 0.0
        }
        
        pickerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(movePicker), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func movePicker() {
        
        var selectedBodyParts: [Int] = []
        var customBodyParts: [String] = []
        
        var selectedActions: [Int] = []
        var customActions: [String] = []
        
        // User Defaults
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "selectedBodyPartsDiceGame") != nil {
            selectedBodyParts = userDefaults.value(forKey: "selectedBodyPartsDiceGame") as! [Int]
        }
        
        if userDefaults.value(forKey: "customBodyPartsDiceGame") != nil {
            customBodyParts = userDefaults.value(forKey: "customBodyPartsDiceGame") as! [String]
        }
        
        if userDefaults.value(forKey: "selectedActionsDiceGame") != nil {
            selectedActions = userDefaults.value(forKey: "selectedActionsDiceGame") as! [Int]
        }
        
        if userDefaults.value(forKey: "customActionsDiceGame") != nil {
            customActions = userDefaults.value(forKey: "customActionsDiceGame") as! [String]
        }
        
        
        
        self.pickerViewMoves += 1
        self.position1 = Int(arc4random_uniform(UInt32(self.actionTasksChallenges.count)))
        self.position2 = Int(arc4random_uniform(UInt32(self.bodyPartsChallenges.count)))
        
        self.pickerView1.selectRow(position1, inComponent: 0, animated: true)
        self.pickerView1.showsSelectionIndicator = true
        
        self.pickerView2.selectRow(position2, inComponent: 0, animated: true)
        self.pickerView2.showsSelectionIndicator = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.pickerViewMoves >= 23 {  // 23 Spins == 23 * 0.1s == 2.3s
                
                //self.pickerViewMoves = 0
                self.pickerTimer.invalidate()
                
                print("position1 = \(self.position1), position2 = \(self.position2)")
                print("selectedActions.count = \(selectedActions.count), selectedBodyParts.count = \(selectedBodyParts.count)")
                print("actionTasksChallenges.count = \(self.actionTasksChallenges.count), bodyPartsChallenges.count = \(self.bodyPartsChallenges.count)")
                var pos1 = self.position1 % self.actionTasksChallenges.count
                var pos2 = self.position2 % self.bodyPartsChallenges.count
                
                var excludedMaleChallenges: [Int] = [3, 4, 5]
                var excludedFemaleChallenges: [Int] = [1, 2, 23]
                
                if self.gameSettingsView.selectedCategory == .cute {
                    
                    pos1 = self.position1 % 14
                    pos2 = self.position2 % 7
                    
                    excludedMaleChallenges = []
                    excludedFemaleChallenges = []
                    
                } else if self.gameSettingsView.selectedCategory == .spicy {
                    
                    pos1 = self.position1 % 17
                    pos2 = self.position2 % 8
                    
                    excludedMaleChallenges = [3, 4, 5]
                    excludedFemaleChallenges = [1, 2, 14]  // 14 is here Taint (last one in list)
                    
                } else if self.gameSettingsView.selectedCategory == .custom {
                    
                    pos1 = self.position1 % selectedActions.count
                    pos2 = self.position2 % selectedBodyParts.count
                    
                    excludedMaleChallenges = [3, 4, 5]
                    excludedFemaleChallenges = [1, 2, 23]
                    
                }
                
                
                // Check if challenge fits to gender
                if self.gameSettingsView.selectedCategory == .custom {
                    
                    print("selectedBodyPartsssss = \(selectedBodyParts)")
                    print("pos1 = \(pos1), pos2 = \(pos2)")
                    let realPos = selectedBodyParts[pos2]-1
                    print("pos1 = \(pos1), pos2 = \(pos2), realPos = \(realPos)")
                    if self.getOpponentPlayerSexuality() == .Male {
                        
                        if excludedMaleChallenges.contains(realPos) {
                            
                            // Pick new Item
                            print("Pick new Item")
                            self.movePickerAgain()
                            return
                            
                        }
                        
                    } else {
                        
                        if excludedFemaleChallenges.contains(realPos) {
                            
                            // Pick new Item
                            print("Pick new Item")
                            self.movePickerAgain()
                            return
                            
                        }
                        
                    }
                    
                } else {
                    
                    if self.getOpponentPlayerSexuality() == .Male {
                        
                        if excludedMaleChallenges.contains(pos2) {
                            
                            // Pick new Item
                            print("Pick new Item")
                            self.movePickerAgain()
                            return
                            
                        }
                        
                    } else {
                        
                        if excludedFemaleChallenges.contains(pos2) {
                            
                            // Pick new Item
                            print("Pick new Item")
                            self.movePickerAgain()
                            return
                            
                        }
                        
                    }
                    
                }
                
                self.pickerViewMoves = 0
                
                DispatchQueue.main.async { [self] in  // chance color of the middle row
                    
                    if let label = pickerView1.view(forRow: position1, forComponent: 0) as? UILabel {
                        label.layer.borderWidth = 3.0
                        label.layer.borderColor = girlAppColor!.cgColor
                    }
                    
                    if let label = pickerView2.view(forRow: position2, forComponent: 0) as? UILabel {
                        label.layer.borderWidth = 3.0
                        label.layer.borderColor = girlAppColor!.cgColor
                    }
                    
                    self.gameSettingsView.isUserInteractionEnabled = true
                    
                    self.gameSettingsView.cuteButton.isUserInteractionEnabled = true
                    self.gameSettingsView.spicyButton.isUserInteractionEnabled = true
                    self.gameSettingsView.customButton.isUserInteractionEnabled = true
                    
                    
                    var randomPlayer = Int(arc4random_uniform(2))
                    if randomPlayer == previousSelectedPlayer {  // when true than already did one turn
                        
                        previousSelectedPlayerCount += 1
                        
                        if previousSelectedPlayerCount >= 2 {
                            
                            previousSelectedPlayerCount = 0
                            
                            if previousSelectedPlayer == 0 {
                                randomPlayer = 1
                            } else {
                                randomPlayer = 0
                            }
                            
                        }
                        
                    }
                    
                    previousSelectedPlayer = randomPlayer
                    
                    if randomPlayer == 0 {
                        self.gameSettingsView.playerNameLabel.text = NSLocalizedString("SqueezLickSuckGame.text.turn", comment: "").replacingOccurrences(of: "%x", with: self.player1Name)
                    } else {
                        self.gameSettingsView.playerNameLabel.text = NSLocalizedString("SqueezLickSuckGame.text.turn", comment: "").replacingOccurrences(of: "%x", with: self.player2Name)
                    }
                    
                    UIView.animate(withDuration: 0.4, delay: 0.0) {
                        self.gameSettingsView.playerNameLabel.alpha = 1.0
                    }
                    
                }
                
            }
        }
        
    }
    
    
    func movePickerAgain() {
        
        self.movePickerAgainCount += 1
        if self.movePickerAgainCount > 10 {
            
            // Alert
            self.showAlertNoSlsTaskFound()
            
            self.movePickerAgainCount = 0
            
        } else {
            
            self.movePicker()
            
        }
        
    }
    
    
    func getCurrentPlayerSexuality() -> Gender {
        
        if self.currentPlayer == .player1 && self.sexuality == 0 {
            
            return .Female
            
        } else if self.currentPlayer == .player2 && self.sexuality == 0 {
            
            return .Male
            
        }
        
        if self.sexuality == 1 {
            
            return .Female
            
        }
        
        if self.sexuality == 2 {
            
            return .Male
            
        }
        
        return .Male
        
    }
    
    
    func getOpponentPlayerSexuality() -> Gender {
        
        if self.currentPlayer == .player1 && self.sexuality == 0 {
            
            return .Male  // Player 1 Female, Player 2 Male
            
        } else if self.currentPlayer == .player2 && self.sexuality == 0 {
            
            return .Female  // Player 1 Male, Player 2 Female
            
        }
        
        if self.sexuality == 1 {
            
            return .Female
            
        }
        
        if self.sexuality == 2 {
            
            return .Male
            
        }
        
        return .Male
        
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == self.pickerView1 {
            return actionTasksChallenges.count
        }
        
        return bodyPartsChallenges.count
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.pickerView1 {
            return actionTasksChallenges[row]
        }
        
        return bodyPartsChallenges[row]
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
            
            pickerView.subviews[1].isHidden = true
        
        let picker = UIView()
        picker.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        label.textColor = UIColor.init(hexString: "4E2E6E")
        
        if pickerView == self.pickerView1 {
            
            label.text = actionTasksChallenges[row]
            // Highlight Position
            if self.position1 == row && self.pickerViewMoves == 0 {
                label.layer.borderWidth = 4.0
                label.layer.borderColor = girlAppColor!.cgColor
            } else {
                label.layer.borderWidth = 0.0
            }
            
        } else {
            
            label.text = bodyPartsChallenges[row]
            
            // Highlight Position
            if self.position2 == row && self.pickerViewMoves == 0 {
                label.layer.borderWidth = 4.0
                label.layer.borderColor = girlAppColor!.cgColor
            } else {
                label.layer.borderWidth = 0.0
            }
            
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            label.layer.cornerRadius = 14.0
        } else {
            label.layer.cornerRadius = 12.0
        }
        
        label.clipsToBounds = true
        label.font = .boldSystemFont(ofSize: 26)
        
        picker.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: picker.topAnchor, constant: 0.0).isActive = true
        label.bottomAnchor.constraint(equalTo: picker.bottomAnchor, constant: 0.0).isActive = true
        label.leftAnchor.constraint(equalTo: picker.leftAnchor, constant: 0.0).isActive = true
        label.rightAnchor.constraint(equalTo: picker.rightAnchor, constant: 0.0).isActive = true
        
        return picker
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            return 70.0
        } else {
            return 60.0
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            return UIScreen.main.bounds.width * 0.35
        } else {
            return UIScreen.main.bounds.width * 0.65
        }
        
    }
    
    
    @objc func closeButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        
        sender.touchDownAnimation {}
        
    }
    
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        
        sender.touchUpAnimation {}
        
    }
    
    
    
    // Press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        self.enterPlayerNameView.player1TextField.resignFirstResponder()
        self.enterPlayerNameView.player2TextField.resignFirstResponder()
        
        return true
        
    }
    
}
