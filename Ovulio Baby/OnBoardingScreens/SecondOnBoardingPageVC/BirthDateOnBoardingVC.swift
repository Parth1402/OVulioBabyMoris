//
//  BirthDateOnBoardingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-26.
//

import UIKit

class BirthDateOnBoardingVC: UIViewController {
    
    var isFieldChanged: (() -> Void)!
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = appColor
        label.font = UIFont.boldSystemFont(ofSize: DeviceSize.fontFor26)
        return label
    }()
    let fatherStaticLabel = UILabel()
    let motherStaticLabel = UILabel()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        setHeadlineLabelText()
    }
    
    func setHeadlineLabelText() {
        headlineLabel.text = "MentruationCycleOnBoardingVC.headlineLabel.text"~ +
        ((ProfileDataBeforeSaving.motherName != nil && ProfileDataBeforeSaving.motherName != "") ? " \(ProfileDataBeforeSaving.motherName ?? "")" : "") +
        ((ProfileDataBeforeSaving.motherName != nil && ProfileDataBeforeSaving.motherName != "" && ProfileDataBeforeSaving.fatherName != nil && ProfileDataBeforeSaving.fatherName != "") ? " and " : "") +
        (ProfileDataBeforeSaving.fatherName != nil ? " \(ProfileDataBeforeSaving.fatherName ?? "")" : "") + "!"
        
        motherStaticLabel.text = ProfileDataBeforeSaving.motherName == nil || ProfileDataBeforeSaving.motherName == "" ? "ProfileVC.ProfileBirthMonthYearCell.Mother.text"~ : ProfileDataBeforeSaving.motherName
        fatherStaticLabel.text = ProfileDataBeforeSaving.fatherName == nil || ProfileDataBeforeSaving.fatherName == "" ? "ProfileVC.ProfileBirthMonthYearCell.Father.text"~ : ProfileDataBeforeSaving.fatherName
    }
    
    func setupUI() {
        setHeadlineLabelText()
        view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55 + (DeviceSize.onbordingContentTopPadding - (DeviceSize.isiPadDevice ? 0 : 25))),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        let headlineDescriptionLabel = CommonView.getCommonLabel(text: "MentruationCycleOnBoardingVC.headlineDescriptionLabel.text"~, textColor: lightAppColor, font: .systemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14), lines: 0, alignment: .center)
        self.view.addSubview(headlineDescriptionLabel)
        NSLayoutConstraint.activate([
            headlineDescriptionLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor, constant: 10),
            headlineDescriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 15),
            headlineDescriptionLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor, constant: -10),
        ])
        
        let birthMonthYearStaticLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.text = "ProfileVC.ProfileBirthMonthYearCell.headlineLabel.text"~
            label.numberOfLines = 0
            label.textColor = appColor
            label.font = UIFont.boldSystemFont(ofSize: DeviceSize.isiPadDevice ? 18 : 16)
            return label
        }()
        view.addSubview(birthMonthYearStaticLabel)
        NSLayoutConstraint.activate([
            birthMonthYearStaticLabel.topAnchor.constraint(equalTo: headlineDescriptionLabel.bottomAnchor, constant: 25),
            birthMonthYearStaticLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            birthMonthYearStaticLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        let motherBirthContainerView = UIView()
        motherBirthContainerView.backgroundColor = .clear
        view.addSubview(motherBirthContainerView)
        motherBirthContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        if !DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                motherBirthContainerView.topAnchor.constraint(equalTo: birthMonthYearStaticLabel.bottomAnchor, constant: 10),
                motherBirthContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                motherBirthContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                motherBirthContainerView.heightAnchor.constraint(equalToConstant: 44),
            ])
        }else{
            NSLayoutConstraint.activate([
                motherBirthContainerView.topAnchor.constraint(equalTo: birthMonthYearStaticLabel.bottomAnchor, constant: 10),
                motherBirthContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                motherBirthContainerView.heightAnchor.constraint(equalToConstant: 44),
                motherBirthContainerView.widthAnchor.constraint(equalToConstant: 425)
            ])
        }
                
        motherStaticLabel.textColor = appColor
        motherStaticLabel.textAlignment = .right
        motherStaticLabel.font = UIFont.systemFont(ofSize: DeviceSize.isiPadDevice ? 18 : 16)
        motherStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        motherBirthContainerView.addSubview(motherStaticLabel)
        NSLayoutConstraint.activate([
            motherStaticLabel.leadingAnchor.constraint(equalTo: motherBirthContainerView.leadingAnchor, constant: 0),
            motherStaticLabel.centerYAnchor.constraint(equalTo: motherBirthContainerView.centerYAnchor),
        ])
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                motherStaticLabel.widthAnchor.constraint(equalToConstant: 120),
            ])
        }
       
        var components = DateComponents()
        components.year = -150
        let minDate = Calendar.current.date(byAdding: components, to: Date())

        components.year = -18
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        let motherDateStackView = DateStackView(dateTobeShown: ProfileDataManager.shared.motherBirthdate, minimunDate: minDate, maximumDate: maxDate)
        motherDateStackView.isFieldChanged = { date in
            if date != ProfileDataManager.shared.motherBirthdate {
                ProfileDataBeforeSaving.motherBirthdate = date
                ProfileDataBeforeSaving.isMotherBirthdateChanged = true
            }else{
                ProfileDataBeforeSaving.isMotherBirthdateChanged = false
            }
            if let action = self.isFieldChanged {
                action()
            }
        }
        motherDateStackView.setupUI()
        motherDateStackView.translatesAutoresizingMaskIntoConstraints = false
        motherBirthContainerView.addSubview(motherDateStackView)
        
        NSLayoutConstraint.activate([
            motherDateStackView.leadingAnchor.constraint(equalTo: motherStaticLabel.trailingAnchor, constant: 15),
            motherDateStackView.trailingAnchor.constraint(equalTo: motherBirthContainerView.trailingAnchor, constant: -40),
        ])
        
        let fatherBirthContainerView = UIView()
        fatherBirthContainerView.backgroundColor = .clear
        view.addSubview(fatherBirthContainerView)
        fatherBirthContainerView.translatesAutoresizingMaskIntoConstraints = false
        if !DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                fatherBirthContainerView.topAnchor.constraint(equalTo: motherBirthContainerView.bottomAnchor, constant: 10),
                fatherBirthContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                fatherBirthContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                fatherBirthContainerView.heightAnchor.constraint(equalToConstant: 44),
            ])
        }else{
            NSLayoutConstraint.activate([
                fatherBirthContainerView.topAnchor.constraint(equalTo: motherBirthContainerView.bottomAnchor, constant: 10),
                fatherBirthContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                fatherBirthContainerView.heightAnchor.constraint(equalToConstant: 44),
                fatherBirthContainerView.widthAnchor.constraint(equalToConstant: 425)
            ])
        }
        
        fatherStaticLabel.textAlignment = .right
        fatherStaticLabel.textColor = appColor
        fatherStaticLabel.font = UIFont.systemFont(ofSize: DeviceSize.isiPadDevice ? 18 : 16)
        fatherStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        fatherBirthContainerView.addSubview(fatherStaticLabel)
        NSLayoutConstraint.activate([
            fatherStaticLabel.leadingAnchor.constraint(equalTo: fatherBirthContainerView.leadingAnchor, constant: 0),
            fatherStaticLabel.centerYAnchor.constraint(equalTo: fatherBirthContainerView.centerYAnchor),
        ])
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                fatherStaticLabel.widthAnchor.constraint(equalToConstant: 120),
            ])
        }
        
        let fatherDateStackView = DateStackView(dateTobeShown: ProfileDataManager.shared.fatherBirthdate, minimunDate: minDate, maximumDate: maxDate)
        fatherDateStackView.isFieldChanged = { date in
            if date != ProfileDataManager.shared.fatherBirthdate {
                ProfileDataBeforeSaving.fatherBirthdate = date
                ProfileDataBeforeSaving.isFatherBirthDateChanged = true
            }else{
                ProfileDataBeforeSaving.isFatherBirthDateChanged = false
            }
            if let action = self.isFieldChanged {
                action()
            }
        }
        fatherDateStackView.setupUI()
        fatherDateStackView.translatesAutoresizingMaskIntoConstraints = false
        fatherBirthContainerView.addSubview(fatherDateStackView)
        
        NSLayoutConstraint.activate([
            fatherDateStackView.leadingAnchor.constraint(equalTo: fatherStaticLabel.trailingAnchor, constant: 15),
            fatherDateStackView.trailingAnchor.constraint(equalTo: fatherBirthContainerView.trailingAnchor, constant: -40),
        ])
    }

}
