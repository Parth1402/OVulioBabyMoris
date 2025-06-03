//
//  NameGenerateImagTextCell.swift
//  Ovulio Baby
//
//  Created by USER on 09/04/25.
//

import UIKit

class NameGenerateImagTextCell: UITableViewCell {
    
    let RegionTF: UITextField = {
        let RegionTF = UITextField()
        RegionTF.translatesAutoresizingMaskIntoConstraints = false
        RegionTF.placeholder = "NameGenerateVC.region.placeholder.text"~
        RegionTF.font = .systemFont(ofSize: 14.pulse2Font())
        RegionTF.backgroundColor = .clear
        RegionTF.textColor = appColor
        RegionTF.tintColor = appColor
        return RegionTF
    }()
    
    let LastNameTF: UITextField = {
        let LastNameTF = UITextField()
        LastNameTF.translatesAutoresizingMaskIntoConstraints = false
        LastNameTF.placeholder = "NameGenerateVC.lastnme.placeholder.text"~
        LastNameTF.font = .systemFont(ofSize: 14.pulse2Font())
        LastNameTF.backgroundColor = .clear
        LastNameTF.textColor = appColor
        LastNameTF.tintColor = appColor
        return LastNameTF
    }()
    
    var isFieldChanged: (() -> Void)?
    
    var isChooseRegionClick: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        
        let RegionLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = "NameGenerateVC.region.text"~
            label.textColor = appColor
            label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
            return label
        }()
        contentView.addSubview(RegionLabel)
        let motherTFContainer = UIView()
        contentView.addSubview(motherTFContainer)
        motherTFContainer.backgroundColor = .white
        motherTFContainer.dropShadow()
        motherTFContainer.layer.cornerRadius = 12
        motherTFContainer.translatesAutoresizingMaskIntoConstraints = false
        RegionTF.text = NameGenerateDataBeforeSaving.RegionName//NameGenerateManager.shared.Region
        RegionTF.delegate = self
        
        motherTFContainer.addSubview(RegionTF)
        NSLayoutConstraint.activate([
            RegionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            RegionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            RegionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 60 : 30),
            
            motherTFContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motherTFContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            motherTFContainer.topAnchor.constraint(equalTo: RegionLabel.bottomAnchor, constant: 5),
            motherTFContainer.heightAnchor.constraint(equalToConstant: 60),
            
            RegionTF.leadingAnchor.constraint(equalTo: motherTFContainer.leadingAnchor, constant: 15),
            RegionTF.trailingAnchor.constraint(equalTo: motherTFContainer.trailingAnchor, constant: -15),
            RegionTF.topAnchor.constraint(equalTo: motherTFContainer.topAnchor, constant: 0),
            RegionTF.bottomAnchor.constraint(equalTo: motherTFContainer.bottomAnchor, constant: 0),
            
        ])
        
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setImage(UIImage(named: "profileCycleDownIMG"), for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        button1.configuration = configuration
        motherTFContainer.addSubview(button1)
        
        NSLayoutConstraint.activate([
            //  button1.centerXAnchor.constraint(equalTo: motherTFContainer.centerXAnchor),
            button1.centerYAnchor.constraint(equalTo: motherTFContainer.centerYAnchor),
            button1.trailingAnchor.constraint(equalTo: motherTFContainer.trailingAnchor, constant: -30),
            button1.widthAnchor.constraint(equalToConstant: (motherTFContainer.frame.width / 2)),
            button1.heightAnchor.constraint(equalToConstant: (44 / 2)),
        ])
                        let RegionTFtapGesture = UITapGestureRecognizer(target: self, action: #selector(RegionTFTapped))
                        RegionTF.addGestureRecognizer(RegionTFtapGesture)
        
        let LastNameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = "NameGenerateVC.lastName.text"~
            label.textColor = appColor
            label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
            return label
        }()
        contentView.addSubview(LastNameLabel)
        let fatherTFContainer = UIView()
        contentView.addSubview(fatherTFContainer)
        fatherTFContainer.backgroundColor = .white
        fatherTFContainer.dropShadow()
        fatherTFContainer.layer.cornerRadius = 12
        fatherTFContainer.translatesAutoresizingMaskIntoConstraints = false
        LastNameTF.text = NameGenerateDataBeforeSaving.LastName//NameGenerateManager.shared.LastName
        LastNameTF.delegate = self
        fatherTFContainer.addSubview(LastNameTF)
        NSLayoutConstraint.activate([
            LastNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            LastNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            LastNameLabel.topAnchor.constraint(equalTo: motherTFContainer
                .bottomAnchor, constant: 15),
            
            fatherTFContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fatherTFContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            fatherTFContainer.topAnchor.constraint(equalTo: LastNameLabel.bottomAnchor, constant: 5),
            fatherTFContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            fatherTFContainer.heightAnchor.constraint(equalToConstant: 60),
            
            LastNameTF.leadingAnchor.constraint(equalTo: fatherTFContainer.leadingAnchor, constant: 15),
            LastNameTF.trailingAnchor.constraint(equalTo: fatherTFContainer.trailingAnchor, constant: -15),
            LastNameTF.topAnchor.constraint(equalTo: fatherTFContainer.topAnchor, constant: 0),
            LastNameTF.bottomAnchor.constraint(equalTo: fatherTFContainer.bottomAnchor, constant: 0),
        ])
        //                let LastNameTFtapGesture = UITapGestureRecognizer(target: self, action: #selector(LastNameTFTapped))
        //                LastNameTF.addGestureRecognizer(LastNameTFtapGesture)
        
        
        
    }

    @objc func RegionTFTapped() {
//        RegionTF.showAnimation {
//        }
            if let action = isChooseRegionClick {
                action()
            
        }
    }
    
    @objc func LastNameTFTapped() {
        LastNameTF.showAnimation {
        }
    }
    
    @objc func dismissPicker() {
        self.contentView.endEditing(true)
    }
    
}


extension NameGenerateImagTextCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //textField.showAnimation {}
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        

        if let action = self.isFieldChanged {
            
            if textField == RegionTF {
                if textField.text != NameGenerateManager.shared.Region {
                    NameGenerateDataBeforeSaving.RegionName = textField.text ?? ""
                    NameGenerateDataBeforeSaving.isRegionNameChanged = true
                } else {
                    NameGenerateDataBeforeSaving.isRegionNameChanged = false
                }
                action()
            }
            
            if textField == LastNameTF {
                if textField.text != NameGenerateManager.shared.LastName {
                    NameGenerateDataBeforeSaving.LastName = textField.text ?? ""
                    NameGenerateDataBeforeSaving.isLastNameChanged = true
                } else {
                    NameGenerateDataBeforeSaving.isLastNameChanged = false
                }
                action()
            }
            
        }
        
    }
}
