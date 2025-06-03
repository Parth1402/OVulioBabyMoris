//
//  ProfileMentruationCycleCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-17.
//

import UIKit

class ProfileMentruationCycleCell: UITableViewCell {
    
    var optedCycleLenghtCouter = 0
    let cycleLenghtTF = UITextField()
    let numberPicker = UIPickerView()
    let cycleLengthPickerTF = UITextField()
    
    var isFieldChanged: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        let headlineLable: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = "ProfileVC.ProfileMentruationCycleCell.headlineLabel.text"~
            label.numberOfLines = 0
            label.textColor = appColor
            label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
            return label
        }()
        contentView.addSubview(headlineLable)
        NSLayoutConstraint.activate([
            headlineLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 10 : 10),
            headlineLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headlineLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
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
        contentView.addSubview(dateStackView)
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: headlineLable.bottomAnchor, constant: DeviceSize.isiPadDevice ? 20 : 15),
            dateStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 20),
        ])
        setUpCycleLengthView(dateStackView: dateStackView)
    }
    
    func setUpCycleLengthView(dateStackView: DateStackView) {
        let cycleLengthContainerView = UIView()
        cycleLengthContainerView.backgroundColor = .clear
        contentView.addSubview(cycleLengthContainerView)
        cycleLengthContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cycleLengthContainerView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: DeviceSize.isiPadDevice ? 20 : 10),
            cycleLengthContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cycleLengthContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            cycleLengthContainerView.heightAnchor.constraint(equalToConstant: 44),
            cycleLengthContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
        
        let chooseYearStaticLabel = UILabel()
        chooseYearStaticLabel.text = "ProfileVC.ProfileMentruationCycleCell.cycleLength.headlineLabel.text"~
        chooseYearStaticLabel.textColor = appColor
        chooseYearStaticLabel.font = UIFont.systemFont(ofSize: 16.pulse2Font())
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
        numberPicker.backgroundColor = .white
        cycleLenghtTF.textAlignment = .center
        optedCycleLenghtCouter = ProfileDataManager.shared.cycleLength ?? 0
        if optedCycleLenghtCouter > 0 {
            numberPicker.selectRow(optedCycleLenghtCouter - 20, inComponent: 0, animated: false)
        }else{
            numberPicker.selectRow(8, inComponent: 0, animated: false)
        }
        if optedCycleLenghtCouter == 0 {
            cycleLenghtTF.placeholder = "28"
        }else{
            cycleLenghtTF.text = "\(optedCycleLenghtCouter)"
        }
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
        
        cycleLengthPickerTF.tintColor = .clear
        cycleLengthPickerTF.delegate = self
        cycleLenghtTF.delegate = self
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
    
    @objc func cycleLenghtDownTapped() {
        if optedCycleLenghtCouter + 1 >= 41 {
            return
        }else{
            optedCycleLenghtCouter += 1
        }
        cycleLenghtTF.text = "\(optedCycleLenghtCouter)"
        handleCycleLengthUpdation()
    }
    
    @objc func cycleLenghtUpTapped() {
        if optedCycleLenghtCouter - 1 <= 0 {
            return
        }else{
            optedCycleLenghtCouter -= 1
        }
        cycleLenghtTF.text = "\(optedCycleLenghtCouter)"
        handleCycleLengthUpdation()
    }
    
    func handleCycleLengthUpdation() {
        self.contentView.superview?.superview?.endEditing(true)
        if optedCycleLenghtCouter != ProfileDataManager.shared.cycleLength {
            ProfileDataBeforeSaving.cycleLength = optedCycleLenghtCouter
            ProfileDataBeforeSaving.isCycleLengthChanged = true
        }else{
            ProfileDataBeforeSaving.isCycleLengthChanged = false
        }
        if let action = isFieldChanged {
            action()
        }
    }
}

extension ProfileMentruationCycleCell: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == cycleLenghtTF {
            if let value = Int(textField.text ?? "0") {
                if value > 40 {
                    textField.text = "40"
                    optedCycleLenghtCouter = 40
                }else{
                    optedCycleLenghtCouter = value
                }
                handleCycleLengthUpdation()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == cycleLengthPickerTF) {
            cycleLenghtTF.showAnimation { }
        }
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


