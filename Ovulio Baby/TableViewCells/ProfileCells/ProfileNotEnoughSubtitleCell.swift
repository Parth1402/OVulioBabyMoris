//
//  ProfileNotEnoughSubtitleCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-18.
//

import UIKit

class ProfileNotEnoughSubtitleCell: UITableViewCell {

    let customLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        customLabel.text = "ProfileVC.ProfileNotEnoughSubtitleCell.headlineLabel.text"~
        contentView.addSubview(customLabel)
        customLabel.textColor = appColor
        customLabel.font = UIFont.systemFont(ofSize: 14)

        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            customLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            customLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
