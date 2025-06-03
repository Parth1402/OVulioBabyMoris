//
//  GamesExtrasPlaceCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-23.
//

import UIKit
import Blurberry

class GamesExtrasPlaceCell: UITableViewCell {
    
    var containerView: UIView!
    var checkBoxImageView: UIImageView!
    var headlineLabel: UILabel!
    var blurView = UIView()
    var blurEffectView: UIVisualEffectView!
    
    override func prepareForReuse() {
        containerView.removeFromSuperview()
        checkBoxImageView.removeFromSuperview()
        headlineLabel.removeFromSuperview()
        if blurEffectView != nil {
            blurEffectView.removeFromSuperview()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setUpCell(extrasData: ExtrasModel?) {
        containerView = UIView()
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        checkBoxImageView = UIImageView()
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        checkBoxImageView.contentMode = .scaleAspectFit
        if extrasData?.isAlreadyCompleted ?? false {
            checkBoxImageView.image = UIImage(named: "placeCheckedImage")
        } else {
            checkBoxImageView.image = UIImage(named: "placeUncheckedImage")
        }
        containerView.addSubview(checkBoxImageView)
        NSLayoutConstraint.activate([
            checkBoxImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            checkBoxImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkBoxImageView.widthAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 19 : 16),
            checkBoxImageView.heightAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 19 : 16),
        ])
        headlineLabel = CommonView.getCommonLabel(text: extrasData?.headline ?? "Not Found", font: .systemFont(ofSize: 14.pulse2Font()), lines: 0)
        containerView.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 8),
            headlineLabel.centerYAnchor.constraint(equalTo: checkBoxImageView.centerYAnchor),
            headlineLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            headlineLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        var pointsText = "\(extrasData?.points ?? 0)"
        if extrasData?.points == 1 {
            pointsText = pointsText + " " + NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.Point.text", comment: "")
        } else {
            pointsText = pointsText + " " + NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.Points.text", comment: "")
        }
        
        let pointsLabel = CommonView.getCommonLabel(text: "+" + pointsText, textColor: lightAppColor, font: .systemFont(ofSize: 14.pulse2Font()))
        containerView.addSubview(pointsLabel)
        NSLayoutConstraint.activate([
            pointsLabel.leadingAnchor.constraint(equalTo: headlineLabel.trailingAnchor, constant: 8),
            pointsLabel.centerYAnchor.constraint(equalTo: checkBoxImageView.centerYAnchor),
            pointsLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -20)
        ])
        
    }
    
    func setupblurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.blur.radius = 3.0
        blurEffectView.blur.tintColor = .clear
        self.contentView.addSubview(blurEffectView)
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
