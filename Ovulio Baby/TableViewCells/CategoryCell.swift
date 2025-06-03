//
//  CategoryCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-09.
//

import UIKit

class CategoryCell: UITableViewCell {

    let backgroundImage = UIImageView()
    let categoryTitle = UILabel()
    let categorySubtitle = UILabel()
    let cellBackgroundView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.cellBackgroundView.removeFromSuperview()
    }
    
    func setUpCell() {
        
        let titleTopPadding = 20.0
        let titleLeftPadding = 20.0
        let subtitleTrailingPadding = (ScreenSize.width * 0.3)
        
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cellBackgroundView)
        
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            cellBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            cellBackgroundView.heightAnchor.constraint(equalToConstant: 108)
        ])
        
        cellBackgroundView.addSubview(backgroundImage)
        
        categoryTitle.numberOfLines = 0
        categoryTitle.font = UIFont.boldSystemFont(ofSize: 20)
        categoryTitle.translatesAutoresizingMaskIntoConstraints = false
        categoryTitle.textColor = .white
        cellBackgroundView.addSubview(categoryTitle)
        
        categorySubtitle.numberOfLines = 0
        categorySubtitle.font = UIFont.systemFont(ofSize: 12)
        categorySubtitle.textColor = .white
        categorySubtitle.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundView.addSubview(categorySubtitle)
        
        NSLayoutConstraint.activate([
            categoryTitle.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: titleTopPadding),
            categoryTitle.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: titleLeftPadding),
            categoryTitle.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -subtitleTrailingPadding),

            categorySubtitle.bottomAnchor.constraint(lessThanOrEqualTo: cellBackgroundView.bottomAnchor),
            categorySubtitle.topAnchor.constraint(equalTo: categoryTitle.bottomAnchor, constant: 0),
            categorySubtitle.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 20),
            categorySubtitle.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -(ScreenSize.width * 0.4)),
        ])
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor),
        ])
        
    }
    
}
