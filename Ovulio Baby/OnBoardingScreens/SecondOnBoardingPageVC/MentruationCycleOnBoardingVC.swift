//
//  MentruationCycleOnBoardingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-26.
//

import UIKit

class MentruationCycleOnBoardingVC: UIViewController {
    
    var optedCycleLenghtCouter = 0
    let cycleLenghtTF = NoPasteTextField()
    let cycleLengthPickerTF = NoPasteTextField()
    let numberPicker = UIPickerView()
    
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
        
        let mentruationHeadlineLable: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.text = "ProfileVC.ProfileMentruationCycleCell.headlineLabel.text"~
            label.numberOfLines = 0
            label.textColor = appColor
            label.font = UIFont.boldSystemFont(ofSize: 16)
            return label
        }()
        view.addSubview(mentruationHeadlineLable)
        NSLayoutConstraint.activate([
            mentruationHeadlineLable.leadingAnchor.constraint(equalTo: headlineDescriptionLabel.leadingAnchor, constant: 10),
            mentruationHeadlineLable.topAnchor.constraint(equalTo: headlineDescriptionLabel.bottomAnchor, constant: 25),
            mentruationHeadlineLable.trailingAnchor.constraint(equalTo: headlineDescriptionLabel.trailingAnchor, constant: -10),
        ])
        
        var components = DateComponents()
        components.year = -150
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        let dateStackView = DateStackView(dateTobeShown: ProfileDataManager.shared.lastPeriodDate, minimunDate: minDate, maximumDate: Date())
        dateStackView.isFieldChanged = { date in
            if date != ProfileDataManager.shared.lastPeriodDate {
                ProfileDataBeforeSaving.lastPeriodDate = date
                ProfileDataBeforeSaving.isLastPeriodDateChanged = true
            }else{
                ProfileDataBeforeSaving.isLastPeriodDateChanged = false
            }
            if let action = self.isFieldChanged {
                action()
            }
        }
        dateStackView.setupUI()
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateStackView)
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: mentruationHeadlineLable.bottomAnchor, constant: 15),
            dateStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            dateStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 20),
        ])
        setUpCycleLengthView(dateStackView: dateStackView)
    }
    
    func setUpCycleLengthView(dateStackView: DateStackView) {
        let cycleLengthContainerView = UIView()
        cycleLengthContainerView.backgroundColor = .clear
        view.addSubview(cycleLengthContainerView)
        cycleLengthContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cycleLengthContainerView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 25),
            cycleLengthContainerView.heightAnchor.constraint(equalToConstant: 44),
            cycleLengthContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let chooseYearStaticLabel = UILabel()
        chooseYearStaticLabel.text = "ProfileVC.ProfileMentruationCycleCell.cycleLength.headlineLabel.text"~
        chooseYearStaticLabel.textColor = appColor
        chooseYearStaticLabel.font = UIFont.systemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        chooseYearStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        cycleLengthContainerView.addSubview(chooseYearStaticLabel)
        NSLayoutConstraint.activate([
            chooseYearStaticLabel.leadingAnchor.constraint(equalTo: cycleLengthContainerView.leadingAnchor, constant: 15),
            chooseYearStaticLabel.centerYAnchor.constraint(equalTo: cycleLengthContainerView.centerYAnchor),
        ])
        
        let cycleLengthupDownButtonContainer = UIView()
        cycleLengthupDownButtonContainer.backgroundColor = .white
        cycleLengthupDownButtonContainer.layer.cornerRadius = 12
        cycleLengthupDownButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        cycleLengthContainerView.addSubview(cycleLengthupDownButtonContainer)
        NSLayoutConstraint.activate([
            cycleLengthupDownButtonContainer.centerYAnchor.constraint(equalTo: cycleLengthContainerView.centerYAnchor),
            cycleLengthupDownButtonContainer.leadingAnchor.constraint(equalTo: chooseYearStaticLabel.trailingAnchor, constant: 15),
            cycleLengthupDownButtonContainer.trailingAnchor.constraint(equalTo: cycleLengthContainerView.trailingAnchor, constant: -15),
            cycleLengthupDownButtonContainer.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        let upDownButtonContainer = UIView()
        upDownButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        cycleLengthupDownButtonContainer.addSubview(upDownButtonContainer)
        NSLayoutConstraint.activate([
            upDownButtonContainer.trailingAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.trailingAnchor, constant: -12),
            upDownButtonContainer.centerYAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.centerYAnchor),
            upDownButtonContainer.topAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.topAnchor),
            upDownButtonContainer.bottomAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.bottomAnchor),
            upDownButtonContainer.widthAnchor
                .constraint(equalToConstant: 30)
        ])
        
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setImage(UIImage(named: "profileCycleUpIMG"), for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        button1.configuration = configuration
        //        button1.addTarget(self, action: #selector(cycleLenghtUpTapped), for: .touchUpInside)
        upDownButtonContainer.addSubview(button1)
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        button2.configuration = configuration
        button2.setImage(UIImage(named: "profileCycleDownIMG"), for: .normal)
        //        button2.addTarget(self, action: #selector(cycleLenghtDownTapped), for: .touchUpInside)
        upDownButtonContainer.addSubview(button2)
        NSLayoutConstraint.activate([
            
            button1.topAnchor.constraint(equalTo: upDownButtonContainer.topAnchor),
            button1.leadingAnchor.constraint(equalTo: upDownButtonContainer.leadingAnchor),
            button1.trailingAnchor.constraint(equalTo: upDownButtonContainer.trailingAnchor),
            button1.widthAnchor.constraint(equalToConstant: (upDownButtonContainer.frame.width / 2)),
            button1.heightAnchor.constraint(equalToConstant: (44 / 2)),
            
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 0),
            button2.leadingAnchor.constraint(equalTo: upDownButtonContainer.leadingAnchor),
            button2.trailingAnchor.constraint(equalTo: upDownButtonContainer.trailingAnchor),
            button2.widthAnchor.constraint(equalToConstant: (upDownButtonContainer.frame.width / 2)),
            button2.heightAnchor.constraint(equalToConstant: (44 / 2)),
            button2.bottomAnchor.constraint(equalTo: upDownButtonContainer.bottomAnchor),
        ])
        
        cycleLenghtTF.textColor = appColor
        cycleLenghtTF.isUserInteractionEnabled = false
        cycleLenghtTF.delegate = self
        numberPicker.delegate = self
        numberPicker.dataSource = self
        numberPicker.selectRow(8, inComponent: 0, animated: false)
        cycleLenghtTF.keyboardType = .numberPad
        cycleLenghtTF.textAlignment = .center
        cycleLenghtTF.placeholder = "28"
        cycleLenghtTF.font = UIFont.systemFont(ofSize: 16)
        cycleLenghtTF.translatesAutoresizingMaskIntoConstraints = false
        cycleLengthupDownButtonContainer.addSubview(cycleLenghtTF)
        NSLayoutConstraint.activate([
            cycleLenghtTF.leadingAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.leadingAnchor, constant: 20),
            cycleLenghtTF.topAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.topAnchor, constant: 0),
            cycleLenghtTF.trailingAnchor.constraint(equalTo: upDownButtonContainer.leadingAnchor, constant: -8),
            cycleLenghtTF.bottomAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.bottomAnchor, constant: -0),
            cycleLenghtTF.widthAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
        
        
        cycleLengthPickerTF.delegate = self
        cycleLengthPickerTF.tintColor = .clear
        cycleLengthPickerTF.inputView = numberPicker
        cycleLengthPickerTF.translatesAutoresizingMaskIntoConstraints = false
        cycleLengthupDownButtonContainer.addSubview(cycleLengthPickerTF)
        NSLayoutConstraint.activate([
            cycleLengthPickerTF.leadingAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.leadingAnchor),
            cycleLengthPickerTF.topAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.topAnchor),
            cycleLengthPickerTF.trailingAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.trailingAnchor),
            cycleLengthPickerTF.bottomAnchor.constraint(equalTo: cycleLengthupDownButtonContainer.bottomAnchor),
        ])
        
    }
    
//    @objc func cycleLenghtDownTapped() {
//        if optedCycleLenghtCouter + 1 >= 41 {
//            return
//        } else {
//            optedCycleLenghtCouter += 1
//        }
//        cycleLenghtTF.text = "\(optedCycleLenghtCouter)"
//        handleCycleLengthUpdation()
//    }
//
//    @objc func cycleLenghtUpTapped() {
//        if optedCycleLenghtCouter - 1 <= 0 {
//            return
//        } else {
//            optedCycleLenghtCouter -= 1
//        }
//        cycleLenghtTF.text = "\(optedCycleLenghtCouter)"
//        handleCycleLengthUpdation()
//    }
    
    func handleCycleLengthUpdation() {
        
        self.view.superview?.superview?.endEditing(true)
        if optedCycleLenghtCouter != ProfileDataManager.shared.cycleLength {
            ProfileDataBeforeSaving.cycleLength = optedCycleLenghtCouter
            ProfileDataBeforeSaving.isCycleLengthChanged = true
        } else {
            ProfileDataBeforeSaving.isCycleLengthChanged = false
        }
        if let action = isFieldChanged {
            action()
        }
        
    }
    
}

extension MentruationCycleOnBoardingVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//
//        if textField == cycleLenghtTF {
//            if let value = Int(textField.text ?? "0") {
//                if value > 40 {
//                    textField.text = "40"
//                    optedCycleLenghtCouter = 40
//                }else{
//                    optedCycleLenghtCouter = value
//                }
//                handleCycleLengthUpdation()
//            }
//        }
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == cycleLengthPickerTF && (cycleLenghtTF.text == nil || cycleLenghtTF.text == "") {
            cycleLenghtTF.text = "28"
            optedCycleLenghtCouter = 28
            if optedCycleLenghtCouter != ProfileDataManager.shared.cycleLength {
                ProfileDataBeforeSaving.cycleLength = optedCycleLenghtCouter
                ProfileDataBeforeSaving.isCycleLengthChanged = true
            } else {
                ProfileDataBeforeSaving.isCycleLengthChanged = false
            }
            if let action = isFieldChanged {
                action()
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        cycleLenghtTF.showAnimation { }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 21 // 40 - 20 + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 20)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = row + 20
        cycleLenghtTF.text = "\(selectedValue)"
        optedCycleLenghtCouter = selectedValue
        handleCycleLengthUpdation()
    }
    
}
