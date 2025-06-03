//
//  LunarCalendarCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-15.
//

import UIKit

class LunarCalendarCell: UICollectionViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let cellGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    let cellGradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    let resourceImageViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let resourceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let monthTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let boyOrGirlLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellGradientImageView.image = nil
    }
    
    private func setupUI() {
        contentView.addSubview(cellView)
        cellView.addSubview(cellGradientView)
        cellGradientView.addSubview(cellGradientImageView)
        
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cellGradientView.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
            cellGradientView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
            cellGradientView.heightAnchor.constraint(equalTo: cellView.heightAnchor, multiplier: 0.80),
            cellGradientView.widthAnchor.constraint(equalTo: cellView.widthAnchor),

            cellGradientImageView.centerXAnchor.constraint(equalTo: cellGradientView.centerXAnchor),
            cellGradientImageView.centerYAnchor.constraint(equalTo: cellGradientView.centerYAnchor),
            cellGradientImageView.heightAnchor.constraint(equalTo: cellGradientView.heightAnchor),
            cellGradientImageView.widthAnchor.constraint(equalTo: cellGradientView.widthAnchor)
        ])
        
        cellGradientView.addSubview(boyOrGirlLabel)
        cellGradientView.addSubview(monthTitleLabel)
        cellView.addSubview(resourceImageViewContainer)
        resourceImageViewContainer.addSubview(resourceImageView)
        
        NSLayoutConstraint.activate([
            boyOrGirlLabel.leadingAnchor.constraint(equalTo: cellGradientView.leadingAnchor, constant: 10),
            boyOrGirlLabel.trailingAnchor.constraint(equalTo: cellGradientView.trailingAnchor, constant: -10),
            boyOrGirlLabel.bottomAnchor.constraint(equalTo: monthTitleLabel.topAnchor, constant: 0),

            monthTitleLabel.leadingAnchor.constraint(equalTo: cellGradientView.leadingAnchor, constant: 10),
            monthTitleLabel.trailingAnchor.constraint(equalTo: cellGradientImageView.trailingAnchor, constant: -10),
            monthTitleLabel.bottomAnchor.constraint(equalTo: cellGradientView.bottomAnchor, constant: -15),
            
            resourceImageViewContainer.topAnchor.constraint(equalTo: cellView.topAnchor),
            resourceImageViewContainer.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
            resourceImageViewContainer.heightAnchor.constraint(equalTo: cellView.heightAnchor, multiplier: 0.6),
            
            resourceImageView.centerXAnchor.constraint(equalTo: resourceImageViewContainer.centerXAnchor),
            resourceImageView.centerYAnchor.constraint(equalTo: resourceImageViewContainer.centerYAnchor),
            resourceImageView.heightAnchor.constraint(equalTo: resourceImageViewContainer.heightAnchor),
            resourceImageView.widthAnchor.constraint(equalTo: resourceImageViewContainer.widthAnchor)
        ])
    }
    
    func setupContent(data: LunarCalendarContentModel) {
        boyOrGirlLabel.text = data.gender == .boy ? "LunarCalendarVC.LunarCalendarCell.Boy.text"~ : "LunarCalendarVC.LunarCalendarCell.Girl.text"~
        boyOrGirlLabel.textColor = data.gender == .boy ? boyAppColor : girlAppColor
        monthTitleLabel.text = data.month
        monthTitleLabel.textColor = data.gender == .boy ? boyAppColor : girlAppColor
        resourceImageView.image = UIImage(named: data.gender == .boy ? "boyCalendarIMG" : "girlCalendarIMG")
    }
    
}
