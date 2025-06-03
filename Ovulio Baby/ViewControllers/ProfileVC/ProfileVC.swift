//
//  ProfileVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-17.
//

import UIKit

class ProfileDataBeforeSaving {
    static var motherName = ProfileDataManager.shared.motherName
    static var isMotherNameChanged = false
    static var fatherName = ProfileDataManager.shared.fatherName
    static var isFatherNameChanged = false
    static var selectedGender = ProfileDataManager.shared.selectedGender
    static var isGenderChangeed = false
    static var lastPeriodDate = ProfileDataManager.shared.lastPeriodDate
    static var isLastPeriodDateChanged = false
    static var cycleLength = ProfileDataManager.shared.cycleLength
    static var isCycleLengthChanged = false
    static var motherBirthdate = ProfileDataManager.shared.motherBirthdate
    static var isMotherBirthdateChanged = false
    static var fatherBirthdate = ProfileDataManager.shared.fatherBirthdate
    static var isFatherBirthDateChanged = false
}

class ProfileVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    var genderUpdationProtocolDelegate: GenderUpdationProtocol?
    var dismissedWithOutData: ((Bool) -> Void)?
    var isPresentedForProfile = true
    
    var profileContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var saveButtonDidableView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("ProfileVC.buttons.saveChanges.text"~, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = buttonAppLightColor
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBackground()
        self.view.addSubview(profileContentContainer)
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                profileContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                profileContentContainer.widthAnchor.constraint(equalToConstant: 460),
                profileContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                profileContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }else{
            NSLayoutConstraint.activate([
                profileContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                profileContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                profileContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                profileContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        profileContentContainer.addSubview(tableView)
        self.view.addSubview(saveButton)
        setUpNavigationBar()
        setUpSaveButton()
        setUpTableView()
    }
    
    func setUpSaveButton() {
        if isPresentedForProfile {
            // Button Animation
            saveButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
            saveButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        }
        saveButton.addTarget(self, action:#selector(saveButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: DeviceSize.onbordingButtonLeftRightPadding),
            saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -DeviceSize.onbordingButtonLeftRightPadding),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        self.view.addSubview(saveButtonDidableView)
        saveButtonDidableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButtonDidableView.topAnchor.constraint(equalTo: saveButton.topAnchor),
            saveButtonDidableView.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor),
            saveButtonDidableView.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            saveButtonDidableView.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor)
        ])
    }
    
    func setUpTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileImagTextCell.self, forCellReuseIdentifier: "ProfileImagTextCell")
        tableView.register(ProfileGenderSelectionCell.self, forCellReuseIdentifier: "ProfileGenderSelectionCell")
        tableView.register(ProfileMentruationCycleCell.self, forCellReuseIdentifier: "ProfileMentruationCycleCell")
        tableView.register(ProfileBirthMonthYearCell.self, forCellReuseIdentifier: "ProfileBirthMonthYearCell")
        tableView.register(ProfileNotEnoughSubtitleCell.self, forCellReuseIdentifier: "ProfileNotEnoughSubtitleCell")
        if let customNavBarView = customNavBarView {
            tableView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo: profileContentContainer.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: profileContentContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: profileContentContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: 25),
        ])
        
    }
    
    func setUpBackground() {
        
        let backgroundImage = UIImageView(frame: ScreenSize.bounds)
        if isPresentedForProfile {
            backgroundImage.image = UIImage(named: "homeScreenBackground")
        } else {
            backgroundImage.backgroundColor = UIColor(hexString: "FFF2F2")
        }
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
        
    }
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: isPresentedForProfile ? "backButtonImg" : "closeButtonNotEnoughData"),
            titleString: isPresentedForProfile ? "ProfileVC.headlineLabel.text"~ : "ProfileVC.headlineLabel.notEnoughData.text"~
        )
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                if !self.isPresentedForProfile {
                    if ProfileDataManager.shared.lastPeriodDate == nil ||
                        ProfileDataManager.shared.cycleLength == nil ||
                        ProfileDataManager.shared.motherBirthdate == nil {
                        self.dismiss(animated: true)
                        if let action = self.dismissedWithOutData {
                            action(true)
                        }
                    }
                }
                self.dismiss(animated: true)
            }
            self.view.addSubview(customNavBarView)
            customNavBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: isPresentedForProfile ? 0 : 17),
                customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customNavBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
            
        }
        
    }
    
}

// MARK: Actions
extension ProfileVC {
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    func handleFieldChange() {
        
        if ProfileDataBeforeSaving.isMotherNameChanged ||
            ProfileDataBeforeSaving.isFatherNameChanged ||
            ProfileDataBeforeSaving.isGenderChangeed ||
            ProfileDataBeforeSaving.isLastPeriodDateChanged ||
            ProfileDataBeforeSaving.isCycleLengthChanged ||
            ProfileDataBeforeSaving.isMotherBirthdateChanged ||
            ProfileDataBeforeSaving.isFatherBirthDateChanged {
            saveButtonDidableView.isHidden = true
        } else {
            saveButtonDidableView.isHidden = false
        }
        
    }
    
    @objc func saveButtonTapped(sender: UIButton) {
        
        saveButton.showAnimation {
            if ProfileDataBeforeSaving.motherName != nil { ProfileDataManager.shared.updateMotherName(ProfileDataBeforeSaving.motherName!)
            }
            if ProfileDataBeforeSaving.fatherName != nil { ProfileDataManager.shared.updateFatherName(ProfileDataBeforeSaving.fatherName!)
            }
            ProfileDataManager.shared.updateGender(to: ProfileDataBeforeSaving.selectedGender)
            if ProfileDataBeforeSaving.lastPeriodDate != nil { ProfileDataManager.shared.updateLastPeriodDate(ProfileDataBeforeSaving.lastPeriodDate!)
            }
            if ProfileDataBeforeSaving.cycleLength != nil { ProfileDataManager.shared.updateCycleLength(ProfileDataBeforeSaving.cycleLength!)
            }
            if ProfileDataBeforeSaving.motherBirthdate != nil { ProfileDataManager.shared.updateMotherBirthdate(ProfileDataBeforeSaving.motherBirthdate)
            }
            if ProfileDataBeforeSaving.fatherBirthdate != nil { ProfileDataManager.shared.updateFatherBirthdate(ProfileDataBeforeSaving.fatherBirthdate)
            }
            self.saveButtonDidableView.isHidden = false
            if ProfileDataBeforeSaving.isGenderChangeed {
                if let delegate = self.genderUpdationProtocolDelegate {
                    delegate.isGenderChanged()
                }
            }
            ProfileDataBeforeSaving.isMotherNameChanged = false
            ProfileDataBeforeSaving.isFatherNameChanged = false
            ProfileDataBeforeSaving.isGenderChangeed = false
            ProfileDataBeforeSaving.isLastPeriodDateChanged = false
            ProfileDataBeforeSaving.isCycleLengthChanged = false
            ProfileDataBeforeSaving.isMotherBirthdateChanged = false
            ProfileDataBeforeSaving.isFatherBirthDateChanged = false
            
            if !self.isPresentedForProfile {
                if ProfileDataManager.shared.lastPeriodDate != nil &&
                    ProfileDataManager.shared.cycleLength != nil &&
                    ProfileDataManager.shared.motherBirthdate != nil {
                    self.dismiss(animated: true)
                    if let action = self.dismissedWithOutData {
                        action(false)
                    }
                }
            }
        }
        
        
        self.dismiss(animated: true)
        
    }
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if !isPresentedForProfile {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileNotEnoughSubtitleCell", for: indexPath) as! ProfileNotEnoughSubtitleCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImagTextCell", for: indexPath) as! ProfileImagTextCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.isFieldChanged = {
                    self.handleFieldChange()
                }
                cell.setupUI()
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileGenderSelectionCell", for: indexPath) as! ProfileGenderSelectionCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.isFieldChanged = {
                self.handleFieldChange()
            }
            cell.setupUI(headlineTitle: isPresentedForProfile ? "ProfileVC.ProfileGenderSelectionCell.headlineLabel.text"~ : "ProfileVC.ProfileGenderSelectionCell.headlineLabel.notEnoughData.text"~)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMentruationCycleCell", for: indexPath) as! ProfileMentruationCycleCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.isFieldChanged = {
                self.handleFieldChange()
            }
            cell.setupUI()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBirthMonthYearCell", for: indexPath) as! ProfileBirthMonthYearCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.isFieldChanged = {
                self.handleFieldChange()
            }
            cell.setupUI()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
