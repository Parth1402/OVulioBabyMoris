//
//  GameLegsUpVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-01.
//

import UIKit

class GameLegsUpVC: UIViewController {

    var customNavBarView: CustomNavigationBar?
    var DontShowButton: UIButton!
    var GotItButton: UIButton!
    let heightOfButtons = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackground()
        setUpNavigationBar()
        setupButtons()
        setUpImageAndHeadline()
        // Button Animation
//        GotItButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
//        GotItButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        GotItButton.addTarget(self, action:#selector(GotItButtonTapped), for: .touchUpInside)
        
        // Button Animation
//        DontShowButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
//        DontShowButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        DontShowButton.addTarget(self, action:#selector(DontShowButtonTapped), for: .touchUpInside)
    }

    func setUpBackground() {
        let backgroundImage = UIImageView(frame: ScreenSize.bounds)
        backgroundImage.backgroundColor = UIColor(hexString: "FFF2F2")
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
    }
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            rightImage: UIImage(named: "closeButtonNotEnoughData")
        )
        if let customNavBarView = customNavBarView {
            customNavBarView.rightButtonTapped = {
                self.showHomeScreen()
            }
            self.view.addSubview(customNavBarView)
            customNavBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customNavBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
        }
    }
    
    func setUpImageAndHeadline() {
        let imageView = CommonView.getCommonImageView(image: "GameLegsUpIMG")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        ])
        if let customNavBarView = customNavBarView {
            imageView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 0).isActive = true
        }else{
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        let aspectRatioConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1.3, constant: 0)
        aspectRatioConstraint.isActive = true
        
        let headlineLabel = CommonView.getCommonLabel(text: "GameLegsUpVC.headlineLabel.text"~, font: .boldSystemFont(ofSize: 24), lines: 0, alignment: .center)
        headlineLabel.adjustsFontSizeToFitWidth = true
        headlineLabel.minimumScaleFactor = 0.2
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            headlineLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            headlineLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            headlineLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.GotItButton.topAnchor, constant: 20),
        ])
    }
    
    func setupButtons() {
        DontShowButton = CommonView.getCommonButton(title: "GameLegsUpVC.Button.DontShowAgain.headline.text"~, titleColor: appColor, backgroundColor: .white)
        self.view.addSubview(DontShowButton)
        NSLayoutConstraint.activate([
            DontShowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            DontShowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            DontShowButton.heightAnchor.constraint(equalToConstant: heightOfButtons),
            DontShowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        GotItButton = CommonView.getCommonButton(title: "GameLegsUpVC.Button.GotIt.text"~)
        self.view.addSubview(GotItButton)
        
        NSLayoutConstraint.activate([
            GotItButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            GotItButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            GotItButton.heightAnchor.constraint(equalToConstant: 50),
            GotItButton.bottomAnchor.constraint(equalTo: DontShowButton.topAnchor, constant: -10),
        ])
    }
}

// MARK: Actions
extension GameLegsUpVC {
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }

    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    @objc func GotItButtonTapped(sender: UIButton) {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        showHomeScreen()
        
    }
    
    @objc func DontShowButtonTapped(sender: UIButton) {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        GamesDataManager.shared.updateNeedToShowLegsUpScreen(false)
        showHomeScreen()
        
    }
    
    func showHomeScreen() {
        self.dismiss(animated: true)
    }
}
