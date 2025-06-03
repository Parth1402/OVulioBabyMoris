//
//  SalesReviewCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-29.
//

import UIKit

class SalesReviewCell: UICollectionViewCell {
    
    let mainContainerView = UIView()
    let lightPinkAppColor = UIColor(hexString: "FFF2F2") ?? .blue
    let userNameLabel = CommonView.getCommonLabel(text: "", font: .boldSystemFont(ofSize: 16.pulse2Font()))
    let commentDescriptionLabel = CommonView.getCommonLabel(text: "", lines: 0)
    
    override func prepareForReuse() {
        mainContainerView.removeFromSuperview()
        userNameLabel.removeFromSuperview()
        commentDescriptionLabel.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(data: SalesReviewModel) {
        mainContainerView.removeFromSuperview()
        userNameLabel.removeFromSuperview()
        commentDescriptionLabel.removeFromSuperview()
        
        mainContainerView.layer.cornerRadius = 20
        mainContainerView.clipsToBounds = true
        mainContainerView.backgroundColor = lightPinkAppColor
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(mainContainerView)
        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        let starView = StarsView()
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.rating = 5
        mainContainerView.addSubview(starView)
        NSLayoutConstraint.activate([
            starView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: 20),
            starView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 20),
            starView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -20),
            starView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        userNameLabel.text = data.userName
        mainContainerView.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -20),
            userNameLabel.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -20),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        commentDescriptionLabel.text = data.reviewText
        mainContainerView.addSubview(commentDescriptionLabel)
        NSLayoutConstraint.activate([
            commentDescriptionLabel.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: 20),
            commentDescriptionLabel.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 10),
            commentDescriptionLabel.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -20),
            commentDescriptionLabel.bottomAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: -10),
        ])
    }
}
