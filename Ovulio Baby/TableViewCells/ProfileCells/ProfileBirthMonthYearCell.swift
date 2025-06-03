//
//  ProfileBirthMonthYearCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-17.
//

import UIKit

class ProfileBirthMonthYearCell: UITableViewCell {
    
    var isFieldChanged: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        let birthMonthYearStaticLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = "ProfileVC.ProfileBirthMonthYearCell.headlineLabel.text"~
            label.numberOfLines = 0
            label.textColor = appColor
            label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
            return label
        }()
        contentView.addSubview(birthMonthYearStaticLabel)
        NSLayoutConstraint.activate([
            birthMonthYearStaticLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 20 : 10),
            birthMonthYearStaticLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            birthMonthYearStaticLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
        
        let motherBirthContainerView = UIView()
        motherBirthContainerView.backgroundColor = .clear
        contentView.addSubview(motherBirthContainerView)
        motherBirthContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            motherBirthContainerView.topAnchor.constraint(equalTo: birthMonthYearStaticLabel.bottomAnchor, constant: DeviceSize.isiPadDevice ? 20 : 10),
            motherBirthContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motherBirthContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            motherBirthContainerView.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        let motherStaticLabel = UILabel()
        motherStaticLabel.text = "ProfileVC.ProfileBirthMonthYearCell.Mother.text"~
        motherStaticLabel.textColor = appColor
        motherStaticLabel.font = UIFont.systemFont(ofSize: 16)
        motherStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        motherBirthContainerView.addSubview(motherStaticLabel)
        NSLayoutConstraint.activate([
            motherStaticLabel.leadingAnchor.constraint(equalTo: motherBirthContainerView.leadingAnchor, constant: 0),
            motherStaticLabel.centerYAnchor.constraint(equalTo: motherBirthContainerView.centerYAnchor),
            motherStaticLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
       
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
            motherBirthContainerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 20),
        ])
        
        let fatherBirthContainerView = UIView()
        fatherBirthContainerView.backgroundColor = .clear
        contentView.addSubview(fatherBirthContainerView)
        fatherBirthContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fatherBirthContainerView.topAnchor.constraint(equalTo: motherBirthContainerView.bottomAnchor, constant: DeviceSize.isiPadDevice ? 20 : 10),
            fatherBirthContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fatherBirthContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            fatherBirthContainerView.heightAnchor.constraint(equalToConstant: 44),
            fatherBirthContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
        ])
        
        let fatherStaticLabel = UILabel()
        fatherStaticLabel.text = "ProfileVC.ProfileBirthMonthYearCell.Father.text"~
        fatherStaticLabel.textColor = appColor
        fatherStaticLabel.font = UIFont.systemFont(ofSize: 16)
        fatherStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        fatherBirthContainerView.addSubview(fatherStaticLabel)
        NSLayoutConstraint.activate([
            fatherStaticLabel.leadingAnchor.constraint(equalTo: fatherBirthContainerView.leadingAnchor, constant: 0),
            fatherStaticLabel.centerYAnchor.constraint(equalTo: fatherBirthContainerView.centerYAnchor),
            fatherStaticLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
        
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
            fatherBirthContainerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 20),
        ])
    }

}
