//
//  GamesLocationsPlaceCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-23.
//

import UIKit

//class GamesLocationsPlaceCell: UITableViewCell {
//
//    var containerView: UIView!
//    var checkBoxImageView: UIImageView!
//    var headlineLabel: UILabel!
//
//    override func prepareForReuse() {
//        containerView.removeFromSuperview()
//        checkBoxImageView.removeFromSuperview()
//        headlineLabel.removeFromSuperview()
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    func setUpCell(placeData: PlacesModel?) {
//        containerView = UIView()
//        contentView.addSubview(containerView)
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//        checkBoxImageView = UIImageView()
//        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
//        checkBoxImageView.contentMode = .scaleAspectFit
//        if placeData?.isAlreadyCompleted ?? false {
//            checkBoxImageView.image = UIImage(named: "placeCheckedImage")
//        } else {
//            checkBoxImageView.image = UIImage(named: "placeUncheckedImage")
//        }
//        containerView.addSubview(checkBoxImageView)
//        NSLayoutConstraint.activate([
//            checkBoxImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            checkBoxImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            checkBoxImageView.widthAnchor.constraint(equalToConstant: 16),
//            checkBoxImageView.heightAnchor.constraint(equalToConstant: 16),
//        ])
//        headlineLabel = CommonView.getCommonLabel(text: placeData?.headline ?? "Not Found", font: .systemFont(ofSize: 14))
//        containerView.addSubview(headlineLabel)
//        NSLayoutConstraint.activate([
//            headlineLabel.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 8),
//            headlineLabel.centerYAnchor.constraint(equalTo: checkBoxImageView.centerYAnchor),
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
