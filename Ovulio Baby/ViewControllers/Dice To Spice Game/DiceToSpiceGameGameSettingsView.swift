//
//  DiceToSpiceGameGameSettingsView.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 02.10.22.
//

import Foundation
import UIKit
import Device


class DiceToSpiceGameGameSettingsView: UIView {
    
    let playerNameLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = .boldSystemFont(ofSize: 20.pulse2Font())
        labelText.textColor = appColor
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
    }()
    
    
    let descriptionLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = .systemFont(ofSize: 14.pulse2Font())
        labelText.textColor = appColor
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
    let cuteButton = SqueezeLickSuckGameButtonTitleView()
    let spicyButton = SqueezeLickSuckGameButtonTitleView()
    let customButton = SqueezeLickSuckGameButtonTitleView()
    
    
    let diceButton = CommonView.getCommonButton(title: "SqueezLickSuckGame.SqueezeLickSuckGameGameSettingsView.diceButton.title"~)
    
    
    var selectedCategory: DiceToSpiceType = .cute
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
//        self.backgroundColor = UIColor(red: 0.0627, green: 0.0627, blue: 0.0627, alpha: 1.0) /* #101010 */
        
        self.layer.cornerRadius = 24.0
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        
        // Shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 2
        
        
        var contentViewWidth = UIScreen.main.bounds.width
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            contentViewWidth = UIScreen.main.bounds.width * 0.55
        }
        
        
        self.addSubview(playerNameLabel)
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playerNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0).isActive = true
        playerNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        playerNameLabel.widthAnchor.constraint(equalToConstant: contentViewWidth * 0.9).isActive = true
        
        playerNameLabel.text = "Laura's turn" //NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.title", comment: "")
        
        
        
        
        
        self.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: self.playerNameLabel.bottomAnchor, constant: 6.0).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: contentViewWidth * 0.9).isActive = true
        
        descriptionLabel.text = NSLocalizedString("SqueezLickSuckGame.EnterPlayerNameView.levelHeadlineLabel.text", comment: "")  // "Choose a Level" Text
        
        
        
        
        
        self.addSubview(spicyButton)
        spicyButton.translatesAutoresizingMaskIntoConstraints = false
        spicyButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 20.0).isActive = true
        spicyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        spicyButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        spicyButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        spicyButton.titleLabel.text = NSLocalizedString("DiceToSpiceGameMenu.DiceToSpiceGameGameSettingsView.spicyButton.title", comment: "")
        
        
        
        
        
        let paddingFromCenter = contentViewWidth / 4
        
        self.addSubview(cuteButton)
        cuteButton.translatesAutoresizingMaskIntoConstraints = false
        cuteButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 20.0).isActive = true
        cuteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -1 * paddingFromCenter).isActive = true
        cuteButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        cuteButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        cuteButton.titleLabel.text = NSLocalizedString("DiceToSpiceGameMenu.DiceToSpiceGameGameSettingsView.cuteButton.title", comment: "")
        
        
        
        
        
        self.addSubview(customButton)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 20.0).isActive = true
        customButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: paddingFromCenter).isActive = true
        customButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        customButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        customButton.titleLabel.text = NSLocalizedString("DiceToSpiceGameMenu.DiceToSpiceGameGameSettingsView.customButton.title", comment: "")
        
        
        // Button Actions
        cuteButton.checkButton.addTarget(self, action: #selector(cuteButtonAction), for: .touchUpInside)
        cuteButton.checkButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        cuteButton.checkButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        cuteButton.checkButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        spicyButton.checkButton.addTarget(self, action: #selector(spicyButtonAction), for: .touchUpInside)
        spicyButton.checkButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        spicyButton.checkButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        spicyButton.checkButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        customButton.checkButton.addTarget(self, action: #selector(customButtonAction), for: .touchUpInside)
        customButton.checkButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        customButton.checkButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        customButton.checkButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        
        
        
        var bottomButtonsHeight = 54.0
        var bottomButtonsWidth = UIScreen.main.bounds.width * 0.8
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            bottomButtonsHeight = 54.0
            bottomButtonsWidth = UIScreen.main.bounds.width * 0.6
        } else if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            bottomButtonsHeight = 50.0
            bottomButtonsWidth = UIScreen.main.bounds.width * 0.8
        }
        
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        
        
        
        self.addSubview(diceButton)
        diceButton.translatesAutoresizingMaskIntoConstraints = false
        diceButton.widthAnchor.constraint(equalToConstant: bottomButtonsWidth).isActive = true
        diceButton.heightAnchor.constraint(equalToConstant: bottomButtonsHeight).isActive = true
        diceButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0 + -1 * bottomPadding!).isActive = true
        diceButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        
        
        //diceButton.addTarget(self, action: #selector(diceButtonAction), for: .touchUpInside)
        
        // Button Animation
        diceButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        diceButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        diceButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        
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
    
    
    @objc func cuteButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.selectedCategory = .cute
        self.updateButtons()
        
    }
    
    
    @objc func spicyButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.selectedCategory = .spicy
        self.updateButtons()
        
    }
    
    
    @objc func customButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.selectedCategory = .custom
        self.updateButtons()
        
    }
    
    /*
    @objc func touchDownButtonAction(_ sender: UIButton) {
        
        sender.touchDownAnimation {}
        
    }
    
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        
        sender.touchUpAnimation {}
        
    }
    */
    
    func updateButtons() {
        
        if self.selectedCategory == .cute {
            
            cuteButton.checkButton.setImage(UIImage(named: "DiceDifficultySelected"), for: .normal)
            cuteButton.checkButton.backgroundColor = appColor
            
            spicyButton.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            spicyButton.checkButton.backgroundColor = UIColor.white
            
            customButton.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            customButton.checkButton.backgroundColor = UIColor.white
            
        } else if self.selectedCategory == .spicy {
            
            cuteButton.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            cuteButton.checkButton.backgroundColor = UIColor.white
            
            spicyButton.checkButton.setImage(UIImage(named: "DiceDifficultySelected"), for: .normal)
            spicyButton.checkButton.backgroundColor = appColor
            
            customButton.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            customButton.checkButton.backgroundColor = UIColor.white
            
        } else if self.selectedCategory == .custom {
            
            cuteButton.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            cuteButton.checkButton.backgroundColor = UIColor.white
            
            spicyButton.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            spicyButton.checkButton.backgroundColor = UIColor.white
            
            customButton.checkButton.setImage(UIImage(named: "DiceDifficultySelected"), for: .normal)
            customButton.checkButton.backgroundColor = appColor
            
        } else if self.selectedCategory == .none {
            
            cuteButton.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            cuteButton.checkButton.backgroundColor = UIColor.white
            
            spicyButton.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            spicyButton.checkButton.backgroundColor = UIColor.white
            
            customButton.checkButton.setImage(UIImage(named: "DiceDifficultyUnselected"), for: .normal)
            customButton.checkButton.backgroundColor = UIColor.white
            
        }
        
    }
    
}



public enum DiceToSpiceType: UInt {
    
    case cute
    
    case spicy
    
    case custom
    
    case none
    
}


public enum Gender: UInt {
    
    case Female
    
    case Male
    
}


public enum Player: UInt {
    
    case player1
    
    case player2
    
}


public enum SlsLevel: UInt {
    
    case Beginner
    
    case Dirty
    
    case Custom
    
}


class DiceButton: GradientAccentColorButton {  // UIButton
    
    let titleTextLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = UIFont(name: "Poppins-Bold", size: 28.0)  //UIFont(name: "Poppins-Regular", size: 16.0)
        labelText.textColor = .white
        labelText.textAlignment = .left
        labelText.numberOfLines = 1
        
        return labelText
        
    }()
    
    
    let iconImageView: UIImageView = {
        
        let imageViewIcon = UIImageView()
        imageViewIcon.backgroundColor = UIColor.clear
        imageViewIcon.contentMode = .scaleAspectFit
        
        return imageViewIcon
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = appColor!.withAlphaComponent(0.7)
        self.layer.cornerRadius = 14.0
        
        
        
        self.addSubview(titleTextLabel)
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        titleTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 14.0).isActive = true
        
        
        
        self.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        //iconImageView.rightAnchor.constraint(equalTo: self.titleTextLabel.leftAnchor, constant: -8.0).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            titleTextLabel.font = UIFont(name: "Teko-Bold", size: 30.0)
            iconImageView.rightAnchor.constraint(equalTo: self.titleTextLabel.leftAnchor, constant: -8.0).isActive = true
            iconImageView.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        } else if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            titleTextLabel.font = UIFont(name: "Teko-Bold", size: 26.0)
            iconImageView.rightAnchor.constraint(equalTo: self.titleTextLabel.leftAnchor, constant: -3.0).isActive = true
            iconImageView.widthAnchor.constraint(equalToConstant: 26.0).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        } else {
            titleTextLabel.font = UIFont(name: "Teko-Bold", size: 28.0)
            iconImageView.rightAnchor.constraint(equalTo: self.titleTextLabel.leftAnchor, constant: -8.0).isActive = true
            iconImageView.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}


class SqueezeLickSuckGameButtonTitleView: UIView {
    
    let checkButton: UIButton = {
        
        let buttonCheck = UIButton()
        buttonCheck.backgroundColor = UIColor.white
        buttonCheck.setImage(UIImage(named: "Onboarding Page Legal Text Check Box not clicked"), for: .normal)
        buttonCheck.isUserInteractionEnabled = true
        
        return buttonCheck
        
    }()
    
    
    let titleLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = UIFont(name: "Poppins-Bold", size: 18.0)
        labelText.textColor = appColor
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
    var checkButtonClicked: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        
        
        self.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 1.0).isActive = true
        checkButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        checkButton.layer.cornerRadius = 15.0
        checkButton.isUserInteractionEnabled = true
        
        
        
        
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.checkButton.bottomAnchor, constant: 8.0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        
        titleLabel.text = NSLocalizedString("SqueezLickSuckGame.SqueezeLickSuckGameGameSettingsView.suckButton.title", comment: "")
        
        
        
        
        
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            titleLabel.font = UIFont(name: "Poppins-Bold", size: 16.0)
            checkButton.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
            checkButton.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
            checkButton.layer.cornerRadius = 12.0
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
