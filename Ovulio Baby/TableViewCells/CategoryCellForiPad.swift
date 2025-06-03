//
//  CategoryCellForiPad.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-03-01.
//

import UIKit

class CategoryCellForiPad: UITableViewCell {

    var categoryContainer1 = UIView()
    var categoryContainer2 = UIView()
    var categoryTapped: ((_ menu: HomeMenus) -> Void)?
    var data1: HomeCategoriesForList!
    var data2: HomeCategoriesForList?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.categoryContainer1.removeFromSuperview()
        self.categoryContainer2.removeFromSuperview()
    }
    
    func setUpCell(data1: HomeCategoriesForList?, data2: HomeCategoriesForList?) {
        
        self.data1 = data1
        self.data2 = data2
        if !(data1 == nil) {
            categoryContainer1.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(categoryContainer1)
            NSLayoutConstraint.activate([
                categoryContainer1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                categoryContainer1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                categoryContainer1.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                categoryContainer1.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.49),
            ])
            getView(data: data1!, categoryContainer: &categoryContainer1)
            let button1 = UIButton(type: .system)
            button1.translatesAutoresizingMaskIntoConstraints = false
            button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
            categoryContainer1.addSubview(button1)
            NSLayoutConstraint.activate([
                button1.leadingAnchor.constraint(equalTo: categoryContainer1.leadingAnchor),
                button1.topAnchor.constraint(equalTo: categoryContainer1.topAnchor),
                button1.trailingAnchor.constraint(equalTo: categoryContainer1.trailingAnchor),
                button1.bottomAnchor.constraint(equalTo: categoryContainer1.bottomAnchor),
            ])
        }
        
        if !(data2 == nil) {
            categoryContainer2.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(categoryContainer2)
            NSLayoutConstraint.activate([
                categoryContainer2.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                categoryContainer2.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                categoryContainer2.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                categoryContainer2.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.49),
            ])
            getView(data: data2!, categoryContainer: &categoryContainer2)
            let button2 = UIButton(type: .system)
            button2.translatesAutoresizingMaskIntoConstraints = false
            button2.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)
            categoryContainer2.addSubview(button2)
            NSLayoutConstraint.activate([
                button2.leadingAnchor.constraint(equalTo: categoryContainer2.leadingAnchor),
                button2.topAnchor.constraint(equalTo: categoryContainer2.topAnchor),
                button2.trailingAnchor.constraint(equalTo: categoryContainer2.trailingAnchor),
                button2.bottomAnchor.constraint(equalTo: categoryContainer2.bottomAnchor),
            ])
        }
    }
    
    @objc func button1Tapped() {
        self.categoryContainer1.showAnimation {
            if let action = self.categoryTapped {
                action(self.data1.homeMenu ?? .Sales)
            }
        }
    }
    
    @objc func button2Tapped() {
        self.categoryContainer2.showAnimation {
            if let action = self.categoryTapped {
                action(self.data2?.homeMenu ?? .Sales)
            }
        }
    }
     
    func getView(data: HomeCategoriesForList, categoryContainer: inout UIView) {
        let backgroundImage = UIImageView()
        let categoryTitle = UILabel()
        let categorySubtitle = UILabel()
        let cellBackgroundView = UIView()
        
        cellBackgroundView.layer.cornerRadius = 20
        cellBackgroundView.layer.masksToBounds = true
        
        if data.image == "upgradeCategoryBackground" {

            DispatchQueue.main.async {

                if let color1 = UIColor(hexString: "EFB8C2"),
                   let color2 = UIColor(hexString: "FFBACB") {
                    cellBackgroundView.gradientBorder(
                        width: 5,
                        colors: [color1, color2],
                        andRoundCornersWithRadius: 18
                    )

                }

            }

            DispatchQueue.main.async {
                if isUserProMember() {
                    self.categoryContainer2.isHidden = true
                } else {
                    self.categoryContainer2.isHidden = false
                }
            }

        }
        
        categoryTitle.text = data.title
        categorySubtitle.text = data.subTitle
        backgroundImage.image = UIImage(named: data.image ?? "gamesCategoryBackground")

        
        let titleTopPadding = 20.0
        let titleLeftPadding = 20.0
        let subtitleTrailingPadding = ((ScreenSize.width / 2) * 0.3)

        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        categoryContainer.addSubview(cellBackgroundView)

        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: categoryContainer.topAnchor, constant: 7),
            cellBackgroundView.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: -6),
            cellBackgroundView.heightAnchor.constraint(equalToConstant: 112)
        ])

        cellBackgroundView.addSubview(backgroundImage)

        categoryTitle.numberOfLines = 0
        categoryTitle.font = UIFont.boldSystemFont(ofSize: 20.pulseWithFont(withInt: 1))
        categoryTitle.translatesAutoresizingMaskIntoConstraints = false
        categoryTitle.textColor = .white
        cellBackgroundView.addSubview(categoryTitle)

        categorySubtitle.numberOfLines = 0
        categorySubtitle.font = UIFont.systemFont(ofSize: 12.pulseWithFont(withInt: 1))
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
            categorySubtitle.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -((ScreenSize.width / 2) * 0.4)),
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
