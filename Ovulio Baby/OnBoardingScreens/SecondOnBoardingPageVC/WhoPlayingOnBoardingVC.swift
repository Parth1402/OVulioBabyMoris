//
//  WhoPlayingOnBoardingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-25.
//

import UIKit

class WhoPlayingOnBoardingVC: UIViewController {

    let motherNameTF: UITextField = {
        let motherNameTF = UITextField()
        motherNameTF.translatesAutoresizingMaskIntoConstraints = false
        motherNameTF.placeholder = "ProfileVC.ProfileImagTextCell.enterMotherName.text"~
        motherNameTF.font = .systemFont(ofSize: 14)
        motherNameTF.backgroundColor = .clear
        motherNameTF.textColor = appColor
        motherNameTF.tintColor = appColor
        return motherNameTF
    }()
    
    let fatherNameTF: UITextField = {
        let fatherNameTF = UITextField()
        fatherNameTF.translatesAutoresizingMaskIntoConstraints = false
        fatherNameTF.placeholder = "ProfileVC.ProfileImagTextCell.enterFatherName.text"~
        fatherNameTF.font = .systemFont(ofSize: 14)
        fatherNameTF.backgroundColor = .clear
        fatherNameTF.textColor = appColor
        fatherNameTF.tintColor = appColor
        return fatherNameTF
    }()
    
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
        
        let bottomBackgroundImageView = CommonView.getCommonImageView(image: "coupleSecondOnBoardingIMG")
        bottomBackgroundImageView.contentMode = .scaleAspectFit
        bottomBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBackgroundImageView)
        NSLayoutConstraint.activate([
            bottomBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            bottomBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(ScreenSize.height * 0.18)),
            bottomBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
            bottomBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: DeviceSize.isiPadDevice ? 0.38 : 0.3)
        ])
        setupUI()
    }
    
    func setupUI() {
        
        let headlineLabel = CommonView.getCommonLabel(text: "WhoPlayingOnBoardingVC.headlineLabel.text"~, font: .boldSystemFont(ofSize: DeviceSize.fontFor26), lines: 0, alignment: .center)
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55 + (DeviceSize.onbordingContentTopPadding - (DeviceSize.isiPadDevice ? 0 : 25))),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        let motherNameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = "ProfileVC.ProfileImagTextCell.Mother.text"~
            label.textColor = appColor
            label.font = UIFont.mymediumSystemFont(ofSize: 13)
            return label
        }()
        view.addSubview(motherNameLabel)
        let motherTFContainer = UIView()
        view.addSubview(motherTFContainer)
        motherTFContainer.backgroundColor = .white
        motherTFContainer.dropShadow()
        motherTFContainer.layer.cornerRadius = 12
        motherTFContainer.translatesAutoresizingMaskIntoConstraints = false
        motherNameTF.text = ProfileDataManager.shared.motherName
        motherNameTF.delegate = self
        motherTFContainer.addSubview(motherNameTF)
        NSLayoutConstraint.activate([
            motherNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding),
            motherNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding),
            motherNameLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 20),

            motherTFContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding),
            motherTFContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding),
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
            label.font = UIFont.mymediumSystemFont(ofSize: 13)
            return label
        }()
        view.addSubview(fatherNameLabel)
        let fatherTFContainer = UIView()
        view.addSubview(fatherTFContainer)
        fatherTFContainer.backgroundColor = .white
        fatherTFContainer.dropShadow()
        fatherTFContainer.layer.cornerRadius = 12
        fatherTFContainer.translatesAutoresizingMaskIntoConstraints = false
        fatherNameTF.text = ProfileDataManager.shared.fatherName
        fatherNameTF.delegate = self
        fatherTFContainer.addSubview(fatherNameTF)
        NSLayoutConstraint.activate([
            fatherNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding),
            fatherNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding),
            fatherNameLabel.topAnchor.constraint(equalTo: motherTFContainer
                .bottomAnchor, constant: 15),

            fatherTFContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding),
            fatherTFContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding),
            fatherTFContainer.topAnchor.constraint(equalTo: fatherNameLabel.bottomAnchor, constant: 5),
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
//        motherNameTF.showAnimation {
//        }
    }
    
    @objc func fatherNameTFTapped() {
//        fatherNameTF.showAnimation {
//        }
    }
}

extension WhoPlayingOnBoardingVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //textField.showAnimation {}
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let action = self.isFieldChanged{
            if textField == motherNameTF {
                if textField.text != ProfileDataManager.shared.motherName &&
                    textField.text != ""  {
                    ProfileDataBeforeSaving.motherName = textField.text ?? ""
                    ProfileDataBeforeSaving.isMotherNameChanged = true
                }else{
                    ProfileDataBeforeSaving.motherName = textField.text ?? ""
                    ProfileDataBeforeSaving.isMotherNameChanged = false
                }
                action()
            }
            
            if textField == fatherNameTF {
                if textField.text != ProfileDataManager.shared.fatherName &&
                    textField.text != "" {
                    ProfileDataBeforeSaving.fatherName = textField.text ?? ""
                    ProfileDataBeforeSaving.isFatherNameChanged = true
                }else{
                    ProfileDataBeforeSaving.fatherName = textField.text ?? ""
                    ProfileDataBeforeSaving.isFatherNameChanged = false
                }
                action()
            }
        }
    }
    
}
