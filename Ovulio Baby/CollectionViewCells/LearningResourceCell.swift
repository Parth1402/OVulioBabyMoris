//
//  LearningResourceCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-12.
//

import UIKit

class LearningResourceCell: UICollectionViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let cellGradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "learningResourceBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let resourceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let resourceTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let resourceTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = appColor
        label.font = UIFont.mymediumSystemFont(ofSize: 14.pulse2Font())
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cellView)
        cellView.addSubview(cellGradientImageView)
        
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cellGradientImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            cellGradientImageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            cellGradientImageView.topAnchor.constraint(equalTo: cellView.topAnchor),
            cellGradientImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
        ])
        
        contentView.addSubview(resourceImageView)
        contentView.addSubview(resourceTitleView)
        resourceTitleView.addSubview(resourceTitleLabel)
        
        NSLayoutConstraint.activate([
            resourceTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            resourceTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            resourceTitleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            resourceTitleView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.35),
            
            resourceTitleLabel.leadingAnchor.constraint(equalTo: resourceTitleView.leadingAnchor, constant: 10),
            resourceTitleLabel.trailingAnchor.constraint(equalTo: resourceTitleView.trailingAnchor, constant: -10),
            resourceTitleLabel.topAnchor.constraint(equalTo: resourceTitleView.topAnchor, constant: 2),
            resourceTitleLabel.bottomAnchor.constraint(equalTo: resourceTitleView.bottomAnchor, constant: -2),
            
            resourceImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            resourceImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resourceImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.55),
        ])
    }
    
    func setupContent(title: String, image: String) {
        resourceTitleLabel.text = title
        resourceImageView.image = UIImage(named: image)
    }
    
}
