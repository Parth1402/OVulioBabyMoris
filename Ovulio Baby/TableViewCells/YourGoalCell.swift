//
//  YourGoalCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-08.
//

import UIKit

class YourGoalCell: UITableViewCell {
    
    let clickButton = UIButton()
    
    let backgroundImage = UIImageView()
    let yourGoalLabel = UILabel()
    let conceiveLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor(hexString: "FFF8FD")
        
        DispatchQueue.main.async {
            backgroundView.layer.cornerRadius = 20
            backgroundView.layer.masksToBounds = true
            
            let dottedBorderLayer = CAShapeLayer()
            dottedBorderLayer.lineWidth = 4
            dottedBorderLayer.strokeColor = UIColor.purple.cgColor
            dottedBorderLayer.lineDashPattern = [4, 4]
            dottedBorderLayer.fillColor = nil
            dottedBorderLayer.path = UIBezierPath(roundedRect: backgroundView.bounds, cornerRadius: 20).cgPath
            backgroundView.layer.addSublayer(dottedBorderLayer)
        }
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            backgroundView.heightAnchor.constraint(equalToConstant: 148)
        ])
        
        backgroundView.addSubview(backgroundImage)
        
        yourGoalLabel.text = "HomeViewController.YourGoalCell.headlineLabel.text"~
        yourGoalLabel.textColor = appColor
        yourGoalLabel.font = UIFont.boldSystemFont(ofSize: 20)
        yourGoalLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(yourGoalLabel)
        
        updateCellContent()
        
        conceiveLabel.textColor = appColor
        conceiveLabel.numberOfLines = 0
        conceiveLabel.font = UIFont.systemFont(ofSize: 14)
        conceiveLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(conceiveLabel)
        
        
        NSLayoutConstraint.activate([
            yourGoalLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 35),
            yourGoalLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            yourGoalLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -150),
            conceiveLabel.topAnchor.constraint(equalTo: yourGoalLabel.bottomAnchor, constant: 0),
            conceiveLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            conceiveLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -170),
        ])
        
        let height = yourGoalLabel.text!.height(withConstrainedWidth: backgroundView.bounds.width - 150, font: yourGoalLabel.font) +
        conceiveLabel.text!.height(withConstrainedWidth: backgroundView.bounds.width - 150, font: conceiveLabel.font) + 105
        
        backgroundImage.contentMode = DeviceSize.isiPadDevice ? .bottomRight : .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.backgroundColor = UIColor(hexString: "FFF8FD")
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                backgroundImage.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
                backgroundImage.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
                backgroundImage.widthAnchor.constraint(equalToConstant: 480),
                backgroundImage.heightAnchor.constraint(equalToConstant: height)
            ])
        }else{
            NSLayoutConstraint.activate([
                backgroundImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                backgroundImage.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
                backgroundImage.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
                backgroundImage.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
                backgroundImage.heightAnchor.constraint(equalToConstant: height)
            ])
        }
        
        backgroundView.addSubview(clickButton)
        clickButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clickButton.topAnchor.constraint(equalTo: self.topAnchor),
            clickButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            clickButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            clickButton.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        clickButton.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellContent() {
        
        var conceiveString = "HomeViewController.YourGoalCell.conceiveChildLabel.text"~
        var backgroundImageName = DeviceSize.isiPadDevice ? "yourGoalBackgroundiPad" : "yourGoalBackground"
        
        if ProfileDataManager.shared.selectedGender == .boy {
            conceiveString = "HomeViewController.YourGoalCell.conceiveBoyLabel.text"~
            backgroundImageName = DeviceSize.isiPadDevice ? "yourGoalBoyImgiPad" : "yourGoalBoyImg"
        }
        
        if ProfileDataManager.shared.selectedGender == .girl {
            conceiveString = "HomeViewController.YourGoalCell.conceiveGirlLabel.text"~
            backgroundImageName = DeviceSize.isiPadDevice ? "yourGoalGirlImgiPad" : "yourGoalGirlImg"
        }
        
        conceiveLabel.text = conceiveString
        backgroundImage.image = UIImage(named: backgroundImageName)
        
    }
    
}
