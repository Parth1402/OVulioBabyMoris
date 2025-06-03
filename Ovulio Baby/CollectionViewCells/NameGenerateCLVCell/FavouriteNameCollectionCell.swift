//
//  FavouriteNameCollectionCell.swift
//  Ovulio Baby
//
//  Created by USER on 14/04/25.
//

import UIKit

class FavouriteNameCollectionCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = appColor
        label.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        label.textAlignment = .left
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("✕", for: .normal)
        button.isUserInteractionEnabled = false
        button.setTitleColor(appColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 0
        contentView.clipsToBounds = false
        contentView.dropShadow()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            closeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI(headlineTitle: String) {
        titleLabel.text = headlineTitle
    }

    func setSelectedAppearance(_ selected: Bool) {
        if selected {
            contentView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
            contentView.layer.borderWidth = 2
        } else {
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0
        }
        contentView.dropShadow()
    }
}
