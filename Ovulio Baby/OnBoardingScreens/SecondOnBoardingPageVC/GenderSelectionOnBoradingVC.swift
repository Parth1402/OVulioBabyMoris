//
//  GenderSelectionOnBoradingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-26.
//

import UIKit

class GenderSelectionOnBoradingVC: UIViewController {
    
    let headlineLabel = CommonView.getCommonLabel(text: "YourGoalSelectionVC.headlineLabel.text"~, font: .boldSystemFont(ofSize: 26), lines: 0, alignment: .center)
    
    var genderUpdationProtocolDelegate: GenderUpdationProtocol?
    let boyBorderView = UIView()
    let girlBorderView = UIView()
    let doesntMatterBorderView = UIView()
    let buttonViewHeight = 55.0
    var isFieldChanged: (() -> Void)!
    
    init(isFieldChanged: @escaping (() -> Void)) {
        super.init(nibName: nil, bundle: nil)
        self.isFieldChanged = isFieldChanged
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55 + (DeviceSize.onbordingContentTopPadding - (DeviceSize.isiPadDevice ? 0 : 25))),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        let bottomBackgroundImageView = CommonView.getCommonImageView(image: "GenderSelectionOnBoradingVCIMG")
        bottomBackgroundImageView.contentMode = .scaleAspectFit
        bottomBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBackgroundImageView)
        NSLayoutConstraint.activate([
            bottomBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            bottomBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(ScreenSize.height * 0.20)),
            bottomBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
            bottomBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
        
        makeBoyGoalView()
        makeGirlGoalView()
        makeDoesntMatterGoalView()
    }
    
    @objc func handleGoalSelection(_ sender: UIButton) {
        let buttonTag = sender.tag
        self.boyBorderView.layer.borderWidth = 0
        self.girlBorderView.layer.borderWidth = 0
        self.doesntMatterBorderView.layer.borderWidth = 0
        switch buttonTag {
        case 1:
            boyBorderView.showAnimation({
                self.boyBorderView.layer.borderWidth = 2
                ProfileDataBeforeSaving.selectedGender = .boy
                ProfileDataBeforeSaving.isGenderChangeed = true
                if let action = self.isFieldChanged {
                    action()
                }
            })
            break
        case 2:
            girlBorderView.showAnimation({
                self.girlBorderView.layer.borderWidth = 2
                ProfileDataBeforeSaving.selectedGender = .girl
                ProfileDataBeforeSaving.isGenderChangeed = true
                if let action = self.isFieldChanged {
                    action()
                }
            })
            break
        case 3:
            doesntMatterBorderView.showAnimation({
                self.doesntMatterBorderView.layer.borderWidth = 2
                ProfileDataBeforeSaving.selectedGender = .doesntMatter
                ProfileDataBeforeSaving.isGenderChangeed = true
                if let action = self.isFieldChanged {
                    action()
                }
            })
            break
        default:
            break
        }
    }
    
    func handleFieldChange() {
        if let action = isFieldChanged {
            action()
        }
    }
}

// MARK: Goal Button Views
extension GenderSelectionOnBoradingVC {
    
    func makeBoyGoalView() {
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
//        boyBorderView.tag = 1
//        boyBorderView.addGestureRecognizer(tapGesture)
        boyBorderView.backgroundColor = .white
        self.view.addSubview(boyBorderView)
        boyBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyBorderView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 25),
            boyBorderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            boyBorderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
            boyBorderView.heightAnchor.constraint(equalToConstant: buttonViewHeight)
        ])
        boyBorderView.layer.cornerRadius = 10
        boyBorderView.clipsToBounds = true
        boyBorderView.layer.borderWidth = 0
        boyBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
        boyBorderView.dropShadow()
        
        
        let boyLabel = UILabel()
        boyLabel.font = UIFont.mymediumSystemFont(ofSize: 14)
        boyLabel.text = "YourGoalSelectionVC.gender.boy.text"~
        boyLabel.textAlignment = .center
        boyLabel.textColor = UIColor(hexString: "9A73F9")
        boyLabel.font = .boldSystemFont(ofSize: 18)
        boyBorderView.addSubview(boyLabel)
        boyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyLabel.leadingAnchor.constraint(equalTo: boyBorderView.leadingAnchor),
            boyLabel.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: 0),
            boyLabel.trailingAnchor.constraint(equalTo: boyBorderView.trailingAnchor),
            boyLabel.bottomAnchor.constraint(equalTo: boyBorderView.bottomAnchor),
        ])
        
        let upperButtonForAnimation = UIButton()
        upperButtonForAnimation.tag = 1
        upperButtonForAnimation.translatesAutoresizingMaskIntoConstraints = false
        boyBorderView.addSubview(upperButtonForAnimation)
        NSLayoutConstraint.activate([
            upperButtonForAnimation.leadingAnchor.constraint(equalTo: boyBorderView.leadingAnchor),
            upperButtonForAnimation.trailingAnchor.constraint(equalTo: boyBorderView.trailingAnchor),
            upperButtonForAnimation.topAnchor.constraint(equalTo: boyBorderView.topAnchor),
            upperButtonForAnimation.bottomAnchor.constraint(equalTo: boyBorderView.bottomAnchor),
        ])
        // Button Animation
        upperButtonForAnimation.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        upperButtonForAnimation.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        upperButtonForAnimation.addTarget(self, action: #selector(handleGoalSelection(_:)), for: .touchUpInside)
    }

    @objc func touchDownButtonAction(_ sender: UIButton) {
        guard let superView = sender.superview else { return }
        superView.touchDownAnimation {}
    }
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        guard let superView = sender.superview else {
                    return
                }
        superView.touchUpAnimation {}
    }
    
    func makeGirlGoalView() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
//        girlBorderView.tag = 2
//        girlBorderView.addGestureRecognizer(tapGesture)
        
        girlBorderView.backgroundColor = .white
        girlBorderView.layer.removeAllAnimations()
        girlBorderView.layer.removeFromSuperlayer()
        self.view.addSubview(girlBorderView)
        girlBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            girlBorderView.topAnchor.constraint(equalTo: boyBorderView.bottomAnchor, constant: 10),
            girlBorderView.leadingAnchor.constraint(equalTo: boyBorderView.leadingAnchor),
            girlBorderView.trailingAnchor.constraint(equalTo: boyBorderView.trailingAnchor),
            girlBorderView.heightAnchor.constraint(equalToConstant: buttonViewHeight)
        ])
        girlBorderView.layer.cornerRadius = 10
        girlBorderView.clipsToBounds = true
        girlBorderView.layer.borderWidth = 0
        girlBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
        girlBorderView.dropShadow()
        
        
        let girlLabel = UILabel()
        girlLabel.font = UIFont.mymediumSystemFont(ofSize: 14)
        girlLabel.text = "YourGoalSelectionVC.gender.girl.text"~
        girlLabel.textAlignment = .center
        girlLabel.textColor = girlAppColor
        girlLabel.font = .boldSystemFont(ofSize: 18)
        girlBorderView.addSubview(girlLabel)
        girlLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            girlLabel.leadingAnchor.constraint(equalTo: girlBorderView.leadingAnchor),
            girlLabel.topAnchor.constraint(equalTo: girlBorderView.topAnchor, constant: 0),
            girlLabel.trailingAnchor.constraint(equalTo: girlBorderView.trailingAnchor),
            girlLabel.bottomAnchor.constraint(equalTo: girlBorderView.bottomAnchor),
        ])
        
        let upperButtonForAnimation = UIButton()
        upperButtonForAnimation.tag = 2
        upperButtonForAnimation.translatesAutoresizingMaskIntoConstraints = false
        girlBorderView.addSubview(upperButtonForAnimation)
        NSLayoutConstraint.activate([
            upperButtonForAnimation.leadingAnchor.constraint(equalTo: girlBorderView.leadingAnchor),
            upperButtonForAnimation.trailingAnchor.constraint(equalTo: girlBorderView.trailingAnchor),
            upperButtonForAnimation.topAnchor.constraint(equalTo: girlBorderView.topAnchor),
            upperButtonForAnimation.bottomAnchor.constraint(equalTo: girlBorderView.bottomAnchor),
        ])
        // Button Animation
        upperButtonForAnimation.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        upperButtonForAnimation.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        upperButtonForAnimation.addTarget(self, action: #selector(handleGoalSelection(_:)), for: .touchUpInside)
    }
    
    func makeDoesntMatterGoalView() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
//        doesntMatterBorderView.tag = 3
//        doesntMatterBorderView.addGestureRecognizer(tapGesture)
        
        doesntMatterBorderView.backgroundColor = .white
        self.view.addSubview(doesntMatterBorderView)
        doesntMatterBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doesntMatterBorderView.topAnchor.constraint(equalTo: girlBorderView.bottomAnchor, constant: 10),
            doesntMatterBorderView.leadingAnchor.constraint(equalTo: boyBorderView.leadingAnchor),
            doesntMatterBorderView.trailingAnchor.constraint(equalTo: boyBorderView.trailingAnchor),
            doesntMatterBorderView.heightAnchor.constraint(equalToConstant: buttonViewHeight)
        ])
        doesntMatterBorderView.layer.cornerRadius = 10
        doesntMatterBorderView.clipsToBounds = true
        doesntMatterBorderView.layer.borderWidth = 0
        doesntMatterBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
        doesntMatterBorderView.dropShadow()
        
        
        let doesntMatterLabel = UILabel()
        doesntMatterLabel.font = .boldSystemFont(ofSize: 18)
        doesntMatterLabel.text = "YourGoalSelectionVC.gender.doesntMatter.text"~
        doesntMatterLabel.numberOfLines = 0
        doesntMatterLabel.textAlignment = .center
        doesntMatterLabel.textColor = UIColor(hexString: "7C49AE")
        doesntMatterBorderView.addSubview(doesntMatterLabel)
        doesntMatterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doesntMatterLabel.leadingAnchor.constraint(equalTo: doesntMatterBorderView.leadingAnchor, constant: 0),
            doesntMatterLabel.topAnchor.constraint(equalTo: doesntMatterBorderView.topAnchor, constant: 0),
            doesntMatterLabel.trailingAnchor.constraint(equalTo: doesntMatterBorderView.trailingAnchor, constant: 0),
            doesntMatterLabel.bottomAnchor.constraint(equalTo: doesntMatterBorderView.bottomAnchor),
        ])
        
        let upperButtonForAnimation = UIButton()
        upperButtonForAnimation.tag = 3
        upperButtonForAnimation.translatesAutoresizingMaskIntoConstraints = false
        doesntMatterBorderView.addSubview(upperButtonForAnimation)
        NSLayoutConstraint.activate([
            upperButtonForAnimation.leadingAnchor.constraint(equalTo: doesntMatterBorderView.leadingAnchor),
            upperButtonForAnimation.trailingAnchor.constraint(equalTo: doesntMatterBorderView.trailingAnchor),
            upperButtonForAnimation.topAnchor.constraint(equalTo: doesntMatterBorderView.topAnchor),
            upperButtonForAnimation.bottomAnchor.constraint(equalTo: doesntMatterBorderView.bottomAnchor),
        ])
        // Button Animation
        upperButtonForAnimation.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        upperButtonForAnimation.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        upperButtonForAnimation.addTarget(self, action: #selector(handleGoalSelection(_:)), for: .touchUpInside)
    }
}
