//
//  OptionsTBLCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-27.
//

import UIKit

class OptionsTBLCell: UITableViewCell {
    
    let titleLabel = CommonView.getCommonLabel(text: "", font: .mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 20 : 15))
    
    let arrowImageView = CommonView.getCommonImageView(image: "optionsArrowIMG")
    
    let itemImageView = CommonView.getCommonImageView(image: "optionsArrowIMG")
    
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
    
    func setupCell(isRightImageNeeded: Bool = false) {
        
        if isRightImageNeeded {
            
            contentView.addSubview(itemImageView)
            NSLayoutConstraint.activate([
                itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                
                itemImageView.heightAnchor.constraint(equalToConstant: 22),
                itemImageView.widthAnchor.constraint(equalToConstant: 22),
            ])
            
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(separatorView)
        arrowImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: (isRightImageNeeded ? itemImageView.trailingAnchor : contentView.leadingAnchor), constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: 16),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            arrowImageView.widthAnchor.constraint(equalToConstant: 30),
            
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.2)
        ])
        
        if isRightImageNeeded {
            NSLayoutConstraint.activate([
                itemImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ])
        }
        
    }

}
