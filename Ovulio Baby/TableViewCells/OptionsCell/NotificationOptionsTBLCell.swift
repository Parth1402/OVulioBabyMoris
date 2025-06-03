//
//  NotificationOptionsTBLCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-28.
//

import UIKit

class NotificationOptionsTBLCell: UITableViewCell {

    let titleLabel = CommonView.getCommonLabel(text: "", font: .mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 20 : 15), lines: 0)
    let subTitleLabel = CommonView.getCommonLabel(text: "", textColor: lightAppColor, font: .mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 12), lines: 0)
    let switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = girlAppColor
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "CCBFD9")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(switchView)
        contentView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: switchView.leadingAnchor, constant: 16),
            
            switchView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 15),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.2)
        ])
    }
}
