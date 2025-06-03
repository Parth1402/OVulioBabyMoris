//
//  ProfileImagTextCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-17.
//

import UIKit

class ProfileImagTextCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homeScreenAvatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()

    let motherNameTF: UITextField = {
        let motherNameTF = UITextField()
        motherNameTF.translatesAutoresizingMaskIntoConstraints = false
        motherNameTF.placeholder = "ProfileVC.ProfileImagTextCell.enterMotherName.text"~
        motherNameTF.font = .systemFont(ofSize: 14.pulse2Font())
        motherNameTF.backgroundColor = .clear
        motherNameTF.textColor = appColor
        motherNameTF.tintColor = appColor
        return motherNameTF
    }()
    
    let fatherNameTF: UITextField = {
        let fatherNameTF = UITextField()
        fatherNameTF.translatesAutoresizingMaskIntoConstraints = false
        fatherNameTF.placeholder = "ProfileVC.ProfileImagTextCell.enterFatherName.text"~
        fatherNameTF.font = .systemFont(ofSize: 14.pulse2Font())
        fatherNameTF.backgroundColor = .clear
        fatherNameTF.textColor = appColor
        fatherNameTF.tintColor = appColor
        return fatherNameTF
    }()
    
    var isFieldChanged: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupUI() {
        contentView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 42 : 10),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        let motherNameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = "ProfileVC.ProfileImagTextCell.Mother.text"~
            label.textColor = appColor
            label.font = UIFont.mymediumSystemFont(ofSize: 13.pulse2Font())
            return label
        }()
        contentView.addSubview(motherNameLabel)
        let motherTFContainer = UIView()
        contentView.addSubview(motherTFContainer)
        motherTFContainer.backgroundColor = .white
        motherTFContainer.dropShadow()
        motherTFContainer.layer.cornerRadius = 12
        motherTFContainer.translatesAutoresizingMaskIntoConstraints = false
        motherNameTF.text = ProfileDataManager.shared.motherName
        motherNameTF.delegate = self
        motherTFContainer.addSubview(motherNameTF)
        NSLayoutConstraint.activate([
            motherNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motherNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            motherNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: DeviceSize.isiPadDevice ? 60 : 30),

            motherTFContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motherTFContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            motherTFContainer.topAnchor.constraint(equalTo: motherNameLabel.bottomAnchor, constant: 5),
            motherTFContainer.heightAnchor.constraint(equalToConstant: 60),

            motherNameTF.leadingAnchor.constraint(equalTo: motherTFContainer.leadingAnchor, constant: 15),
            motherNameTF.trailingAnchor.constraint(equalTo: motherTFContainer.trailingAnchor, constant: -15),
            motherNameTF.topAnchor.constraint(equalTo: motherTFContainer.topAnchor, constant: 0),
            motherNameTF.bottomAnchor.constraint(equalTo: motherTFContainer.bottomAnchor, constant: 0),
        ])
//        let motherNameTFtapGesture = UITapGestureRecognizer(target: self, action: #selector(motherNameTFTapped))
//        motherNameTF.addGestureRecognizer(motherNameTFtapGesture)
        
        let fatherNameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = "ProfileVC.ProfileImagTextCell.Father.text"~
            label.textColor = appColor
            label.font = UIFont.mymediumSystemFont(ofSize: 13.pulse2Font())
            return label
        }()
        contentView.addSubview(fatherNameLabel)
        let fatherTFContainer = UIView()
        contentView.addSubview(fatherTFContainer)
        fatherTFContainer.backgroundColor = .white
        fatherTFContainer.dropShadow()
        fatherTFContainer.layer.cornerRadius = 12
        fatherTFContainer.translatesAutoresizingMaskIntoConstraints = false
        fatherNameTF.text = ProfileDataManager.shared.fatherName
        fatherNameTF.delegate = self
        fatherTFContainer.addSubview(fatherNameTF)
        NSLayoutConstraint.activate([
            fatherNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fatherNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            fatherNameLabel.topAnchor.constraint(equalTo: motherTFContainer
                .bottomAnchor, constant: 15),

            fatherTFContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fatherTFContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            fatherTFContainer.topAnchor.constraint(equalTo: fatherNameLabel.bottomAnchor, constant: 5),
            fatherTFContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            fatherTFContainer.heightAnchor.constraint(equalToConstant: 60),

            fatherNameTF.leadingAnchor.constraint(equalTo: fatherTFContainer.leadingAnchor, constant: 15),
            fatherNameTF.trailingAnchor.constraint(equalTo: fatherTFContainer.trailingAnchor, constant: -15),
            fatherNameTF.topAnchor.constraint(equalTo: fatherTFContainer.topAnchor, constant: 0),
            fatherNameTF.bottomAnchor.constraint(equalTo: fatherTFContainer.bottomAnchor, constant: 0),
        ])
//        let fatherNameTFtapGesture = UITapGestureRecognizer(target: self, action: #selector(fatherNameTFTapped))
//        fatherNameTF.addGestureRecognizer(fatherNameTFtapGesture)
    }
    
    @objc func motherNameTFTapped() {
        motherNameTF.showAnimation {
        }
    }
    
    @objc func fatherNameTFTapped() {
        fatherNameTF.showAnimation {
        }
    }
    
}


extension ProfileImagTextCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //textField.showAnimation {}
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let action = self.isFieldChanged {
            
            if textField == motherNameTF {
                if textField.text != ProfileDataManager.shared.motherName {
                    ProfileDataBeforeSaving.motherName = textField.text ?? ""
                    ProfileDataBeforeSaving.isMotherNameChanged = true
                } else {
                    ProfileDataBeforeSaving.isMotherNameChanged = false
                }
                action()
            }
            
            if textField == fatherNameTF {
                if textField.text != ProfileDataManager.shared.fatherName {
                    ProfileDataBeforeSaving.fatherName = textField.text ?? ""
                    ProfileDataBeforeSaving.isFatherNameChanged = true
                } else {
                    ProfileDataBeforeSaving.isFatherNameChanged = false
                }
                action()
            }
            
        }
        
    }
    
}
