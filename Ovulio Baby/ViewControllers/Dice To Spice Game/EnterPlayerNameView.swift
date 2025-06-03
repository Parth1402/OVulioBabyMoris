//
//  EnterPlayerNameView.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 25.08.22.
//

import Foundation
import UIKit
import Device


class EnterPlayerNameView: UIView {
    
    let playerNamesLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = .mySystemFont(ofSize: 14.pulse2Font())
        labelText.textColor = appColor
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
//    let straightButton = GenderButton()
//    let lesbianButton = GenderButton()
//    let gayButton = GenderButton()
    
    var selectedSexuality: SexualityType = .straight
    
    var selectedLevel: SlsLevel = .Beginner
    
    
    let player1GenderLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = .systemFont(ofSize: 14.pulse2Font())
        labelText.textColor = appColor
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
    let player2GenderLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = .systemFont(ofSize: 14.pulse2Font())
        labelText.textColor = appColor
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
    let player1TextField: UITextField = {
        let motherNameTF = UITextField()
        motherNameTF.translatesAutoresizingMaskIntoConstraints = false
        motherNameTF.font = .systemFont(ofSize: 14.pulse2Font())
        motherNameTF.backgroundColor = .clear
        motherNameTF.textColor = appColor
        motherNameTF.tintColor = appColor
        return motherNameTF
    }()
    
    let player2TextField: UITextField = {
        let motherNameTF = UITextField()
        motherNameTF.translatesAutoresizingMaskIntoConstraints = false
        motherNameTF.font = .systemFont(ofSize: 14.pulse2Font())
        motherNameTF.backgroundColor = .clear
        motherNameTF.textColor = appColor
        motherNameTF.tintColor = appColor
        return motherNameTF
    }()
    
    
    let letsGoButton = CommonView.getCommonButton(title: "SqueezLickSuckGame.letsGoButton.title"~)
    
    
//    let firstNameBackgroundView = UIView()
    
    
    
    let levelHeadlineLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = UIFont(name: "Poppins-Bold", size: 17.0)
        labelText.textColor = appColor
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
//    let levelBeginnerButton = GenderButton()
//    let levelDirtyButton = GenderButton()
//    let levelCustomButton = GenderButton()
    
    
//    let levelSelectionBackgroundView = UIView()
    
    
    var sexuality: Int = 0  // 0 = straight, 1 = lesbian, 2 = gay, 3 = threesome MFF, 4 = threesome MMF, 3 and 4 not used here
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        
        var contentViewWidth = UIScreen.main.bounds.width
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            contentViewWidth = UIScreen.main.bounds.width * 0.55
        }
        
        
        
//        self.addSubview(firstNameBackgroundView)
//        self.addSubview(levelSelectionBackgroundView)
        
        
        self.addSubview(playerNamesLabel)
        playerNamesLabel.translatesAutoresizingMaskIntoConstraints = false
        playerNamesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22.0).isActive = true
        playerNamesLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        playerNamesLabel.widthAnchor.constraint(equalToConstant: contentViewWidth * 0.8).isActive = true
        
        playerNamesLabel.text = NSLocalizedString("SqueezLickSuckGame.EnterPlayerNameView.playerNamesLabel.text", comment: "")
        
        
        
        
        
//        self.addSubview(lesbianButton)
//        lesbianButton.translatesAutoresizingMaskIntoConstraints = false
//        lesbianButton.topAnchor.constraint(equalTo: self.playerNamesLabel.bottomAnchor, constant: 15.0).isActive = true
//        lesbianButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
//        lesbianButton.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
//        lesbianButton.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
//        
//        lesbianButton.textLabel.text = NSLocalizedString("ViewController.sexualitySettings.alert.action.lesbian", comment: "")
//        lesbianButton.genderIcon.image = UIImage(named: "Lesbian Icon")
//        
//        lesbianButton.genderIcon.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
//        lesbianButton.genderIcon.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
//        lesbianButton.genderIcon.sizeToFit()
        
        
        
        
        
        let paddingFromCenter = contentViewWidth / 4
        
//        self.addSubview(straightButton)
//        straightButton.translatesAutoresizingMaskIntoConstraints = false
//        straightButton.topAnchor.constraint(equalTo: self.playerNamesLabel.bottomAnchor, constant: 15.0).isActive = true
//        straightButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -1 * paddingFromCenter).isActive = true
//        straightButton.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
//        straightButton.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
//        
//        straightButton.textLabel.text = NSLocalizedString("ViewController.sexualitySettings.alert.action.straight", comment: "")
//        straightButton.genderIcon.image = UIImage(named: "Hetero Icon")
//        
//        straightButton.genderIcon.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
//        straightButton.genderIcon.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
//        straightButton.genderIcon.sizeToFit()
        
        
        
        
        
//        self.addSubview(gayButton)
//        gayButton.translatesAutoresizingMaskIntoConstraints = false
//        gayButton.topAnchor.constraint(equalTo: self.playerNamesLabel.bottomAnchor, constant: 15.0).isActive = true
//        gayButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: paddingFromCenter).isActive = true
//        gayButton.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
//        gayButton.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
//        
//        gayButton.textLabel.text = NSLocalizedString("ViewController.sexualitySettings.alert.action.gay", comment: "")
//        gayButton.genderIcon.image = UIImage(named: "Gay Icon")
//        
//        gayButton.genderIcon.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
//        gayButton.genderIcon.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
//        gayButton.genderIcon.sizeToFit()
        
        
        // Button Actions
//        straightButton.addTarget(self, action: #selector(straightButtonAction), for: .touchUpInside)
//        straightButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
//        straightButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
//        straightButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
//        
//        
//        lesbianButton.addTarget(self, action: #selector(lesbianButtonAction), for: .touchUpInside)
//        lesbianButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
//        lesbianButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
//        lesbianButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
//        
//        
//        gayButton.addTarget(self, action: #selector(gayButtonAction), for: .touchUpInside)
//        gayButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
//        gayButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
//        gayButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        
        
        
        self.addSubview(player1GenderLabel)
        player1GenderLabel.translatesAutoresizingMaskIntoConstraints = false
        player1GenderLabel.topAnchor.constraint(equalTo: self.playerNamesLabel.bottomAnchor, constant: 25.0).isActive = true
        player1GenderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        player1GenderLabel.text = NSLocalizedString("SqueezLickSuckGame.playerGender.female", comment: "")
        
        
        
        
        
        self.addSubview(player1TextField)
        player1TextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            player1TextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            player1TextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            player1TextField.topAnchor.constraint(equalTo: player1GenderLabel.bottomAnchor, constant: 3),
            player1TextField.heightAnchor.constraint(equalToConstant: 60)
        ])
//        player1TextField.topAnchor.constraint(equalTo: self.player1GenderLabel.bottomAnchor, constant: 3.0).isActive = true
//        player1TextField.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
//        player1TextField.widthAnchor.constraint(equalToConstant: contentViewWidth * 0.8).isActive = true
//        player1TextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        player1TextField.backgroundColor = UIColor.white
        player1TextField.clearButtonMode = UITextField.ViewMode.never
        player1TextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        player1TextField.adjustsFontSizeToFitWidth = true
        player1TextField.tintColor = appColor
        player1TextField.textColor = UIColor.black
//        player1TextField.attributedPlaceholder = NSAttributedString(
//            string: NSLocalizedString("LocationTrackingAddLocationMenu.locationNameTextField.placeholder", comment: ""),
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.4)]
//        )
        player1TextField.keyboardType = .default
//        player1TextField.textAlignment = .center
        player1TextField.setLeftPaddingPoints(8.0)
        player1TextField.setRightPaddingPoints(8.0)
        
        player1TextField.layer.cornerRadius = 12.0
        player1TextField.layer.borderWidth = 0.0
        player1TextField.layer.borderColor = UIColor.lightGray.cgColor
//        player1TextField.placeholder = NSLocalizedString("LocationTrackingAddLocationMenu.locationNameTextField.placeholder", comment: "")
        
        
        
        
        
        self.addSubview(player2GenderLabel)
        player2GenderLabel.translatesAutoresizingMaskIntoConstraints = false
        player2GenderLabel.topAnchor.constraint(equalTo: self.player1TextField.bottomAnchor, constant: 14.0).isActive = true
        player2GenderLabel.leadingAnchor.constraint(equalTo: player1TextField.leadingAnchor, constant: 0).isActive = true
        
        player2GenderLabel.text = NSLocalizedString("SqueezLickSuckGame.playerGender.male", comment: "")
        
        
        
        
        
        self.addSubview(player2TextField)
        player2TextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            player2TextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            player2TextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            player2TextField.topAnchor.constraint(equalTo: player2GenderLabel.bottomAnchor, constant: 3),
            player2TextField.heightAnchor.constraint(equalToConstant: 60)
        ])
//        player2TextField.topAnchor.constraint(equalTo: self.player2GenderLabel.bottomAnchor, constant: 3.0).isActive = true
//        player2TextField.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
//        player2TextField.widthAnchor.constraint(equalToConstant: contentViewWidth * 0.8).isActive = true
//        player2TextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        player2TextField.backgroundColor = UIColor.white
        player2TextField.clearButtonMode = UITextField.ViewMode.never
        player2TextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        player2TextField.adjustsFontSizeToFitWidth = true
        player2TextField.tintColor = appColor
        player2TextField.textColor = UIColor.black
//        player2TextField.attributedPlaceholder = NSAttributedString(
//            string: NSLocalizedString("LocationTrackingAddLocationMenu.locationNameTextField.placeholder", comment: ""),
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.4)]
//        )
        player2TextField.keyboardType = .default
//        player2TextField.textAlignment = .center
        player2TextField.setLeftPaddingPoints(8.0)
        player2TextField.setRightPaddingPoints(8.0)
        
        player2TextField.layer.cornerRadius = 12.0
        player2TextField.layer.borderWidth = 0.0
        player2TextField.layer.borderColor = UIColor.lightGray.cgColor
//        player2TextField.placeholder = NSLocalizedString("LocationTrackingAddLocationMenu.locationNameTextField.placeholder", comment: "")
        
        
        
        
        
//        firstNameBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        firstNameBackgroundView.topAnchor.constraint(equalTo: self.playerNamesLabel.topAnchor, constant: -16.0).isActive = true
//        firstNameBackgroundView.leftAnchor.constraint(equalTo: self.player2TextField.leftAnchor, constant: -16.0).isActive = true
//        firstNameBackgroundView.rightAnchor.constraint(equalTo: self.player2TextField.rightAnchor, constant: 16.0).isActive = true
//        firstNameBackgroundView.bottomAnchor.constraint(equalTo: self.player2TextField.bottomAnchor, constant: 16.0).isActive = true
//        
//        firstNameBackgroundView.layer.cornerRadius = 20.0
//        firstNameBackgroundView.backgroundColor = UIColor.black
        
        
        
        
        
//        self.addSubview(levelHeadlineLabel)
//        levelHeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
//        levelHeadlineLabel.topAnchor.constraint(equalTo: self.firstNameBackgroundView.bottomAnchor, constant: 30.0).isActive = true
//        levelHeadlineLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
//        levelHeadlineLabel.widthAnchor.constraint(equalToConstant: contentViewWidth * 0.8).isActive = true
//        
//        levelHeadlineLabel.text = NSLocalizedString("SqueezLickSuckGame.EnterPlayerNameView.levelHeadlineLabel.text", comment: "")
        
        
        
        
        
//        self.addSubview(levelDirtyButton)
//        levelDirtyButton.translatesAutoresizingMaskIntoConstraints = false
//        levelDirtyButton.topAnchor.constraint(equalTo: self.levelHeadlineLabel.bottomAnchor, constant: 20.0).isActive = true
//        levelDirtyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
//        levelDirtyButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
//        levelDirtyButton.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
//        
//        levelDirtyButton.textLabel.text = NSLocalizedString("SqueezLickSuckGame.levelButton.level.2", comment: "")
//        levelDirtyButton.genderIcon.image = UIImage(named: "SLS Game Level Dirty")
//        levelDirtyButton.genderIcon.centerXAnchor.constraint(equalTo: self.levelDirtyButton.centerXAnchor, constant: 0.0).isActive = true
//        levelDirtyButton.genderIcon.sizeToFit()
//        
//        
//        
//        
//        
//        self.addSubview(levelBeginnerButton)
//        levelBeginnerButton.translatesAutoresizingMaskIntoConstraints = false
//        levelBeginnerButton.topAnchor.constraint(equalTo: self.levelHeadlineLabel.bottomAnchor, constant: 20.0).isActive = true
//        levelBeginnerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -1 * paddingFromCenter).isActive = true
//        levelBeginnerButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
//        levelBeginnerButton.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
//        
//        levelBeginnerButton.textLabel.text = NSLocalizedString("SqueezLickSuckGame.levelButton.level.1", comment: "")
//        levelBeginnerButton.genderIcon.image = UIImage(named: "SLS Game Level Beginner")
//        levelBeginnerButton.genderIcon.centerXAnchor.constraint(equalTo: self.levelBeginnerButton.centerXAnchor, constant: 0.0).isActive = true
//        levelBeginnerButton.genderIcon.sizeToFit()
//        
//        levelBeginnerButton.backgroundColor = UIColor(red: 0.1412, green: 0.1412, blue: 0.1412, alpha: 1.0) /* #242424 */
//        levelBeginnerButton.layer.cornerRadius = 10.0
//        levelBeginnerButton.layer.borderColor = UIColor.white.cgColor
//        levelBeginnerButton.layer.borderWidth = 2.0
//        
//        
//        
//        
//        
//        self.addSubview(levelCustomButton)
//        levelCustomButton.translatesAutoresizingMaskIntoConstraints = false
//        levelCustomButton.topAnchor.constraint(equalTo: self.levelHeadlineLabel.bottomAnchor, constant: 20.0).isActive = true
//        levelCustomButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: paddingFromCenter).isActive = true
//        levelCustomButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
//        levelCustomButton.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
//        
//        levelCustomButton.textLabel.text = NSLocalizedString("SqueezLickSuckGame.levelButton.level.3", comment: "")
//        levelCustomButton.genderIcon.image = UIImage(named: "SLS Game Level Custom")
//        levelCustomButton.genderIcon.centerXAnchor.constraint(equalTo: self.levelCustomButton.centerXAnchor, constant: 0.0).isActive = true
//        levelCustomButton.genderIcon.sizeToFit()
//        
//        
//        // Button Actions
//        levelBeginnerButton.addTarget(self, action: #selector(levelBeginnerButtonAction), for: .touchUpInside)
//        levelBeginnerButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
//        levelBeginnerButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
//        levelBeginnerButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
//        
//        
//        levelDirtyButton.addTarget(self, action: #selector(levelDirtyButtonAction), for: .touchUpInside)
//        levelDirtyButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
//        levelDirtyButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
//        levelDirtyButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
//        
//        
//        levelCustomButton.addTarget(self, action: #selector(levelCustomButtonAction), for: .touchUpInside)
//        levelCustomButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
//        levelCustomButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
//        levelCustomButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        
        
        
//        levelSelectionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        levelSelectionBackgroundView.topAnchor.constraint(equalTo: self.levelHeadlineLabel.topAnchor, constant: -16.0).isActive = true
//        levelSelectionBackgroundView.leftAnchor.constraint(equalTo: self.levelHeadlineLabel.leftAnchor, constant: -16.0).isActive = true
//        levelSelectionBackgroundView.rightAnchor.constraint(equalTo: self.levelHeadlineLabel.rightAnchor, constant: 16.0).isActive = true
//        levelSelectionBackgroundView.bottomAnchor.constraint(equalTo: self.levelCustomButton.bottomAnchor, constant: 16.0).isActive = true
//        
//        levelSelectionBackgroundView.layer.cornerRadius = 20.0
//        levelSelectionBackgroundView.backgroundColor = UIColor.gray
        
        
        
        
        
        let bottomButtonsHeight = 54.0
        let bottomButtonsWidth = DeviceSize.isiPadDevice ? UIScreen.main.bounds.width * 0.9 : UIScreen.main.bounds.width * 0.9
        self.addSubview(letsGoButton)
        letsGoButton.translatesAutoresizingMaskIntoConstraints = false
        
        letsGoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding).isActive = true
        letsGoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding).isActive = true
        letsGoButton.heightAnchor.constraint(equalToConstant: bottomButtonsHeight).isActive = true
        letsGoButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        letsGoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        
//        letsGoButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0).isActive = true
//        letsGoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
//        //letsGoButton.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
//        if Device.size() <= Size.screen4_7Inch {
//            // Device is iPhone 6s or smaller
//            letsGoButton.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
//        } else {
//            letsGoButton.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
//        }
//        letsGoButton.widthAnchor.constraint(equalToConstant: contentViewWidth * 0.8 + 32.0).isActive = true
        
        letsGoButton.isUserInteractionEnabled = true
//        letsGoButton.setTitle(NSLocalizedString("TruthOrDareGameMenu.playNowButton.title", comment: ""), for: .normal)
        
        // Button Animation
        letsGoButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        letsGoButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        letsGoButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        
        
        
//        firstNameBackgroundView.isHidden = true
//        levelSelectionBackgroundView.isHidden = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
//    @objc func straightButtonAction() {
//        
//        // Success
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//        
//        self.selectedSexuality = .straight
//        self.updateButtons()
//        
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(0, forKey: "sexualitySlsGame")
//        
//        self.endEditing(true)
//        
//    }
//    
//    
//    @objc func lesbianButtonAction() {
//        
//        // Success
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//        
//        self.selectedSexuality = .lesbian
//        self.updateButtons()
//        
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(1, forKey: "sexualitySlsGame")
//        
//        self.endEditing(true)
//        
//    }
//    
//    
//    @objc func gayButtonAction() {
//        
//        // Success
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//        
//        self.selectedSexuality = .gay
//        self.updateButtons()
//        
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(2, forKey: "sexualitySlsGame")
//        
//        self.endEditing(true)
//        
//    }
    
    
//    @objc func levelBeginnerButtonAction() {
//        
//        // Success
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//        
//        self.selectedLevel = .Beginner
//        self.updateButtons()
//        
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(0, forKey: "selectedSlsLevel")
//        
//        self.endEditing(true)
//        
//    }
//    
//    
//    @objc func levelDirtyButtonAction() {
//        
//        // Success
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//        
//        self.selectedLevel = .Dirty
//        self.updateButtons()
//        
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(1, forKey: "selectedSlsLevel")
//        
//        self.endEditing(true)
//        
//    }
    
    
//    @objc func levelCustomButtonAction() {
//        
//        // Success
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//        
//        self.selectedLevel = .Custom
//        self.updateButtons()
//        
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(2, forKey: "selectedSlsLevel")
//        
//        self.endEditing(true)
//        
//    }
    
    /*
    @objc func touchDownButtonAction(_ sender: UIButton) {
        
        sender.touchDownAnimation {}
        
    }
    
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        
        sender.touchUpAnimation {}
        
    }
    */
    
//    func updateButtons() {
//        
//        player1TextField.placeholder = NSLocalizedString("SqueezLickSuckGame.playerGenderTextField.placeholder.player1", comment: "")
//        player2TextField.placeholder = NSLocalizedString("SqueezLickSuckGame.playerGenderTextField.placeholder.player2", comment: "")
//        
//        if self.selectedSexuality == .straight {
//            
//            straightButton.alpha = 1.0
//            lesbianButton.alpha = 0.5
//            gayButton.alpha = 0.5
//            
//            player1GenderLabel.text = NSLocalizedString("SqueezLickSuckGame.playerGender.female", comment: "")
//            player2GenderLabel.text = NSLocalizedString("SqueezLickSuckGame.playerGender.male", comment: "")
//            
//        } else if self.selectedSexuality == .lesbian {
//            
//            straightButton.alpha = 0.5
//            lesbianButton.alpha = 1.0
//            gayButton.alpha = 0.5
//            
//            player1GenderLabel.text = NSLocalizedString("SqueezLickSuckGame.playerGender.female", comment: "")
//            player2GenderLabel.text = NSLocalizedString("SqueezLickSuckGame.playerGender.female", comment: "")
//            
//        } else if self.selectedSexuality == .gay {
//            
//            straightButton.alpha = 0.5
//            lesbianButton.alpha = 0.5
//            gayButton.alpha = 1.0
//            
//            player1GenderLabel.text = NSLocalizedString("SqueezLickSuckGame.playerGender.male", comment: "")
//            player2GenderLabel.text = NSLocalizedString("SqueezLickSuckGame.playerGender.male", comment: "")
//            
//        }
//        
//        
//        
//        if self.selectedLevel == .Beginner {
//            
//            levelBeginnerButton.gradientLayer.isHidden = false  // Apply Gradient Color
//            //levelBeginnerButton.backgroundColor = UIColor(red: 0.1412, green: 0.1412, blue: 0.1412, alpha: 1.0) /* #242424 */
//            levelBeginnerButton.layer.cornerRadius = 10.0
//            levelBeginnerButton.layer.borderColor = UIColor.white.cgColor
//            levelBeginnerButton.layer.borderWidth = 2.0
//            
//            levelDirtyButton.backgroundColor = UIColor.clear
//            levelDirtyButton.layer.borderWidth = 0.0
//            levelDirtyButton.gradientLayer.isHidden = true
//            
//            levelCustomButton.backgroundColor = UIColor.clear
//            levelCustomButton.layer.borderWidth = 0.0
//            levelCustomButton.gradientLayer.isHidden = true
//            
//        } else if self.selectedLevel == .Dirty {
//            
//            levelDirtyButton.gradientLayer.isHidden = false  // Apply Gradient Color
//            //levelDirtyButton.backgroundColor = UIColor(red: 0.1412, green: 0.1412, blue: 0.1412, alpha: 1.0) /* #242424 */
//            levelDirtyButton.layer.cornerRadius = 10.0
//            levelDirtyButton.layer.borderColor = UIColor.white.cgColor
//            levelDirtyButton.layer.borderWidth = 2.0
//            
//            levelBeginnerButton.backgroundColor = UIColor.clear
//            levelBeginnerButton.layer.borderWidth = 0.0
//            levelBeginnerButton.gradientLayer.isHidden = true
//            
//            levelCustomButton.backgroundColor = UIColor.clear
//            levelCustomButton.layer.borderWidth = 0.0
//            levelCustomButton.gradientLayer.isHidden = true
//            
//        } else if self.selectedLevel == .Custom {
//            
//            levelCustomButton.gradientLayer.isHidden = false  // Apply Gradient Color
//            //levelCustomButton.backgroundColor = UIColor(red: 0.1412, green: 0.1412, blue: 0.1412, alpha: 1.0) /* #242424 */
//            levelCustomButton.layer.cornerRadius = 10.0
//            levelCustomButton.layer.borderColor = UIColor.white.cgColor
//            levelCustomButton.layer.borderWidth = 2.0
//            
//            levelBeginnerButton.backgroundColor = UIColor.clear
//            levelBeginnerButton.layer.borderWidth = 0.0
//            levelBeginnerButton.gradientLayer.isHidden = true
//            
//            levelDirtyButton.backgroundColor = UIColor.clear
//            levelDirtyButton.layer.borderWidth = 0.0
//            levelDirtyButton.gradientLayer.isHidden = true
//            
//        }
//        
//    }
    
}




class GenderButton: UIButton {
    
    let genderIcon: UIImageView = {
        
        let iconGender = UIImageView()
        iconGender.backgroundColor = UIColor.clear
        iconGender.contentMode = .scaleAspectFit
        
        return iconGender
        
    }()
    
    
    let textLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = UIFont(name: "Poppins-Bold", size: 13.0)
        labelText.textColor = appColor
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        
        // Apply Gradient Color
        gradientLayer.frame.size = CGSize(width: 80.0, height: 100.0)
        gradientLayer.colors =
        [UIColor.red.cgColor, UIColor.yellow.cgColor]  // Use different colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.cornerRadius = 10.0
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.isHidden = true
        
        
        
        
        
        genderIcon.isUserInteractionEnabled = false
        textLabel.isUserInteractionEnabled = false
        
        
        
        self.addSubview(genderIcon)
        genderIcon.translatesAutoresizingMaskIntoConstraints = false
        genderIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 1.0).isActive = true
        genderIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 8.0).isActive = true
        genderIcon.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        genderIcon.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        
        
        
        
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: self.genderIcon.bottomAnchor, constant: 8.0).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        
        textLabel.text = "Hetero"  //NSLocalizedString("RulesMenu.disclaimer.acceptLabel.text", comment: "")
        
        
        
        
        
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            textLabel.font = UIFont(name: "Poppins-Bold", size: 14.0)
        }
        
        
        /*
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            titleLabel.font = UIFont(name: "Poppins-Bold", size: 30.0)
            subtitleLabel.font = UIFont(name: "Poppins-Regular", size: 20.0)
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6.0).isActive = true
        } else if Device.size() <= Size.screen4_7Inch {
            print("Device is iPhone 6s or smaller")
            titleLabel.font = UIFont(name: "Poppins-Bold", size: 21.0)
            subtitleLabel.font = UIFont(name: "Poppins-Regular", size: 14.0)
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6.0).isActive = true
        } else {
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0).isActive = true
        }
        */
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}


public enum SexualityType: UInt {
    
    case straight
    
    case lesbian
    
    case gay
    
}
