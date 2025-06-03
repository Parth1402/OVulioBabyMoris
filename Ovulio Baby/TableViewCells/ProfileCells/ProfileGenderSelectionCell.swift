//
//  ProfileGenderSelectionCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-17.
//

import UIKit

class ProfileGenderSelectionCell: UITableViewCell {
    
    let buttonContainerView: UIView = {
        let buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        return buttonContainerView
    }()
    
    let boyBorderView = UIView()
    let boyContainerView = UIView()
    
    let girlContainerView = UIView()
    let girlBorderView = UIView()
    
    let doesntMatterContainerView = UIView()
    let doesntMatterBorderView = UIView()
    
    let buttonViewHeight = DeviceSize.isiPadDevice ? 135.0 : 120.0
    let allSpacingForButtons = 40.0
    
    var isFieldChanged: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI(headlineTitle: String) {
        let babyStaticLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = headlineTitle
            label.textColor = appColor
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.numberOfLines = 0
            return label
        }()
        contentView.addSubview(babyStaticLabel)
        NSLayoutConstraint.activate([
            babyStaticLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 20 : 10),
            babyStaticLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            babyStaticLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
        
        contentView.addSubview(buttonContainerView)
        NSLayoutConstraint.activate([
            buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonContainerView.topAnchor.constraint(equalTo: babyStaticLabel.bottomAnchor, constant: 5),
            buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
        ])
        makeBoyGoalView()
        makeGirlGoalView()
        makeDoesntMatterGoalView()
    }
}

// MARK: Actions
extension ProfileGenderSelectionCell {
    
    @objc func handleGoalSelection(_ sender: UITapGestureRecognizer) {
        self.contentView.superview?.superview?.endEditing(true)
        if let buttonTag = sender.view?.tag {
            self.boyBorderView.layer.borderWidth = 0
            self.girlBorderView.layer.borderWidth = 0
            self.doesntMatterBorderView.layer.borderWidth = 0
            switch buttonTag {
            case 1:
                boyContainerView.showAnimation({
                    self.boyBorderView.layer.borderWidth = 2
                    if ProfileDataManager.shared.selectedGender == .boy {
                        ProfileDataBeforeSaving.isGenderChangeed = false
                    }else{
                        ProfileDataBeforeSaving.selectedGender = .boy
                        ProfileDataBeforeSaving.isGenderChangeed = true
                    }
                    if let action = self.isFieldChanged {
                        action()
                    }
                })
                break
            case 2:
                girlContainerView.showAnimation({
                    self.girlBorderView.layer.borderWidth = 2
                    if ProfileDataManager.shared.selectedGender == .girl {
                        ProfileDataBeforeSaving.isGenderChangeed = false
                    }else{
                        ProfileDataBeforeSaving.selectedGender = .girl
                        ProfileDataBeforeSaving.isGenderChangeed = true
                    }
                    if let action = self.isFieldChanged {
                        action()
                    }
                })
                break
            case 3:
                doesntMatterContainerView.showAnimation({
                    self.doesntMatterBorderView.layer.borderWidth = 2
                    if ProfileDataManager.shared.selectedGender == .doesntMatter {
                        ProfileDataBeforeSaving.isGenderChangeed = false
                    }else{
                        ProfileDataBeforeSaving.selectedGender = .doesntMatter
                        ProfileDataBeforeSaving.isGenderChangeed = true
                    }
                    if let action = self.isFieldChanged {
                        action()
                    }
                })
                break
            default:
                break
            }
        }
    }
}

// MARK: Goal Button Views
extension ProfileGenderSelectionCell {
    
    func makeBoyGoalView() {
        boyContainerView.backgroundColor = .clear
        buttonContainerView.addSubview(boyContainerView)
        boyContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyContainerView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            boyContainerView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 15),
            boyContainerView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.33),
            boyContainerView.heightAnchor.constraint(equalToConstant: buttonViewHeight),
            boyContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
        boyContainerView.tag = 1
        boyContainerView.addGestureRecognizer(tapGesture)
        
        boyBorderView.backgroundColor = .white
        boyContainerView.addSubview(boyBorderView)
        boyBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyBorderView.centerXAnchor.constraint(equalTo: boyContainerView.centerXAnchor),
            boyBorderView.bottomAnchor.constraint(equalTo: boyContainerView.bottomAnchor),
            boyBorderView.widthAnchor.constraint(equalToConstant: (((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.33) - 8),
            boyBorderView.heightAnchor.constraint(equalToConstant: (buttonViewHeight - 40))
        ])
        boyBorderView.layer.cornerRadius = 20
        boyBorderView.clipsToBounds = true
        boyBorderView.layer.borderWidth = ProfileDataManager.shared.selectedGender == .boy ? 2 : 0
        boyBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
        boyBorderView.dropShadow()
        
        
        let boyLabel = UILabel()
        boyLabel.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        boyLabel.text = "YourGoalSelectionVC.gender.boy.text"~
        boyLabel.textAlignment = .center
        boyLabel.textColor = appColor
        boyBorderView.addSubview(boyLabel)
        boyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyLabel.leadingAnchor.constraint(equalTo: boyBorderView.leadingAnchor),
            boyLabel.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: 20),
            boyLabel.trailingAnchor.constraint(equalTo: boyBorderView.trailingAnchor),
            boyLabel.bottomAnchor.constraint(equalTo: boyBorderView.bottomAnchor),
        ])
        
        let buttonImageView = UIImageView(image: UIImage(named: "boyButtonIMG"))
        boyContainerView.addSubview(buttonImageView)
        buttonImageView.contentMode = .scaleAspectFit
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonImageView.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: -(((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.22) / 2),
            buttonImageView.centerXAnchor.constraint(equalTo: boyContainerView.centerXAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons - 20) * 0.22),
            buttonImageView.heightAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons - 20) * 0.22),
        ])
    }
    
    func makeGirlGoalView() {
        
        girlContainerView.backgroundColor = .clear
        buttonContainerView.addSubview(girlContainerView)
        girlContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            girlContainerView.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor),
            girlContainerView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 15),
            girlContainerView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.33),
            girlContainerView.heightAnchor.constraint(equalToConstant: buttonViewHeight),
            girlContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
        girlContainerView.tag = 2
        girlContainerView.addGestureRecognizer(tapGesture)
        
        girlBorderView.backgroundColor = .white
        girlBorderView.layer.removeAllAnimations()
        girlBorderView.layer.removeFromSuperlayer()
        girlContainerView.addSubview(girlBorderView)
        girlBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            girlBorderView.centerXAnchor.constraint(equalTo: girlContainerView.centerXAnchor),
            girlBorderView.bottomAnchor.constraint(equalTo: girlContainerView.bottomAnchor),
            girlBorderView.widthAnchor.constraint(equalToConstant: (((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.33) - 8),
            girlBorderView.heightAnchor.constraint(equalToConstant: (buttonViewHeight - 40))
        ])
        
        girlBorderView.layer.cornerRadius = 20
        girlBorderView.clipsToBounds = true
        girlBorderView.layer.borderWidth = ProfileDataManager.shared.selectedGender == .girl ? 2 : 0
        girlBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
        girlBorderView.dropShadow()
        
        
        let boyLabel = UILabel()
        boyLabel.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        boyLabel.text = "YourGoalSelectionVC.gender.girl.text"~
        boyLabel.textAlignment = .center
        boyLabel.textColor = appColor
        girlBorderView.addSubview(boyLabel)
        boyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyLabel.leadingAnchor.constraint(equalTo: girlBorderView.leadingAnchor),
            boyLabel.topAnchor.constraint(equalTo: girlBorderView.topAnchor, constant: 20),
            boyLabel.trailingAnchor.constraint(equalTo: girlBorderView.trailingAnchor),
            boyLabel.bottomAnchor.constraint(equalTo: girlBorderView.bottomAnchor),
        ])
        
        let buttonImageView = UIImageView(image: UIImage(named: "girlButtonIMG"))
        girlContainerView.addSubview(buttonImageView)
        buttonImageView.contentMode = .scaleAspectFit
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonImageView.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: -(((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.22) / 2),
            buttonImageView.centerXAnchor.constraint(equalTo: girlContainerView.centerXAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons - 20) * 0.22),
            buttonImageView.heightAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons - 20) * 0.22),
        ])
    }
    
    func makeDoesntMatterGoalView() {
        
        doesntMatterContainerView.backgroundColor = .clear
        buttonContainerView.addSubview(doesntMatterContainerView)
        doesntMatterContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doesntMatterContainerView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            doesntMatterContainerView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 15),
            doesntMatterContainerView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.33),
            doesntMatterContainerView.heightAnchor.constraint(equalToConstant: buttonViewHeight),
            doesntMatterContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
        doesntMatterContainerView.tag = 3
        doesntMatterContainerView.addGestureRecognizer(tapGesture)
        
        doesntMatterBorderView.backgroundColor = .white
        doesntMatterContainerView.addSubview(doesntMatterBorderView)
        doesntMatterBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doesntMatterBorderView.centerXAnchor.constraint(equalTo: doesntMatterContainerView.centerXAnchor),
            doesntMatterBorderView.bottomAnchor.constraint(equalTo: doesntMatterContainerView.bottomAnchor),
            doesntMatterBorderView.widthAnchor.constraint(equalToConstant: (((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.33) - 8),
            doesntMatterBorderView.heightAnchor.constraint(equalToConstant: (buttonViewHeight - 40))
        ])
        doesntMatterBorderView.layer.cornerRadius = 20
        doesntMatterBorderView.clipsToBounds = true
        doesntMatterBorderView.layer.borderWidth = ProfileDataManager.shared.selectedGender == .doesntMatter ? 2 : 0
        doesntMatterBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
        doesntMatterBorderView.dropShadow()
        
        
        let boyLabel = UILabel()
        boyLabel.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        boyLabel.text = "YourGoalSelectionVC.gender.doesntMatter.text"~
        boyLabel.numberOfLines = 0
        boyLabel.textAlignment = .center
        boyLabel.textColor = appColor
        doesntMatterBorderView.addSubview(boyLabel)
        boyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyLabel.leadingAnchor.constraint(equalTo: doesntMatterBorderView.leadingAnchor, constant: 10),
            boyLabel.topAnchor.constraint(equalTo: doesntMatterBorderView.topAnchor, constant: 25),
            boyLabel.trailingAnchor.constraint(equalTo: doesntMatterBorderView.trailingAnchor, constant: -10),
            boyLabel.bottomAnchor.constraint(equalTo: doesntMatterBorderView.bottomAnchor),
        ])
        
        let buttonImageView = UIImageView(image: UIImage(named: "doesntMatterButtonIMG"))
        doesntMatterContainerView.addSubview(buttonImageView)
        buttonImageView.contentMode = .scaleAspectFit
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonImageView.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: -(((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.22) / 2),
            buttonImageView.centerXAnchor.constraint(equalTo: doesntMatterContainerView.centerXAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons - 20) * 0.22),
            buttonImageView.heightAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons - 20) * 0.22),
        ])
    }
}
