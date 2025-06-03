//
//  CountryTableCell.swift
//  Ovulio Baby
//
//  Created by USER on 11/04/25.
//

import UIKit

class CountryTableCell: UITableViewCell {
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "france_flag") // Replace with real flags if needed
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mymediumSystemFont(ofSize: 15)
        label.textColor = appColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkmarkView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = appColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator // system default separator color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        contentView.addSubview(flagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkmarkView)
        contentView.addSubview(separatorLine)

        
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 25),
            flagImageView.heightAnchor.constraint(equalToConstant: 25),
            
            nameLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkView.heightAnchor.constraint(equalToConstant: 20),
            
            separatorLine.leadingAnchor.constraint(equalTo: flagImageView.leadingAnchor),
             separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
             separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with country: String, isSelected: Bool, flag:UIImage) {
        nameLabel.text = country
        checkmarkView.isHidden = !isSelected
        flagImageView.image = flag
    }
}
