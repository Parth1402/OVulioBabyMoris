//
//  GameLevelCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-20.
//

import UIKit

class GameLevelCell: UICollectionViewCell {
    var containerView = UIView()
    var blackBakcgroundView = UIView()
    override func prepareForReuse() {
        self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.blackBakcgroundView.alpha = 0.3
        blackBakcgroundView.removeFromSuperview()
        containerView.removeFromSuperview()
    }
    
    func setupCell(levelData: GameLevelModel) {
        self.containerView = CommonView.getViewWithShadowAndRadius(cornerRadius: 22)
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ])
        let levelHeadlineLabel = CommonView.getCommonLabel(text: levelData.headline, font: .boldSystemFont(ofSize: 16.pulse2Font()))
        containerView.addSubview(levelHeadlineLabel)
        NSLayoutConstraint.activate([
            levelHeadlineLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            levelHeadlineLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: DeviceSize.isiPadDevice ? 16 : 20),
            levelHeadlineLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        var complexityLabelText = NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.easy.headlineLabel.text", comment: "")
        if levelData.complexity == .easy {
            complexityLabelText = NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.easy.headlineLabel.text", comment: "")
        } else if levelData.complexity == .medium {
            complexityLabelText = NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.medium.headlineLabel.text", comment: "")
        } else if levelData.complexity == .complicated {
            complexityLabelText = NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.complicated.headlineLabel.text", comment: "")
        } else if levelData.complexity == .sparkling {
            complexityLabelText = NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.sparkling.headlineLabel.text", comment: "")
        } else if levelData.complexity == .kinky {
            complexityLabelText = NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.kinky.headlineLabel.text", comment: "")
        } else if levelData.complexity == .captivating {
            complexityLabelText = NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.captivating.headlineLabel.text", comment: "")
        }
        
        let complexityLabel = CommonView.getCommonLabel(text: complexityLabelText, font: .systemFont(ofSize: 14.pulse2Font()))
        containerView.addSubview(complexityLabel)
        NSLayoutConstraint.activate([
            complexityLabel.leadingAnchor.constraint(equalTo: levelHeadlineLabel.leadingAnchor),
            complexityLabel.topAnchor.constraint(equalTo: levelHeadlineLabel.bottomAnchor, constant: DeviceSize.isiPadDevice ? 2 : 5),
            complexityLabel.trailingAnchor.constraint(equalTo: levelHeadlineLabel.trailingAnchor),
        ])
        let starView = StarsView()
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.rating = levelData.complexity.stars
        containerView.addSubview(starView)
        NSLayoutConstraint.activate([
            starView.leadingAnchor.constraint(equalTo: levelHeadlineLabel.leadingAnchor),
            starView.topAnchor.constraint(equalTo: complexityLabel.bottomAnchor, constant: 6),
            starView.trailingAnchor.constraint(equalTo: levelHeadlineLabel.trailingAnchor, constant: -20),
            starView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        var pointsText = "\(levelData.pointPerCard)"
        if levelData.pointPerCard == 1 {
            pointsText = pointsText + " " + NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.Point.text", comment: "")
        } else {
            pointsText = pointsText + " " + NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.Points.text", comment: "")
        }
        
        let pointsLabel = CommonView.getCommonLabel(text: "+" + pointsText, textColor: lightAppColor, font: .systemFont(ofSize: 14.pulse2Font()))
        containerView.addSubview(pointsLabel)
        NSLayoutConstraint.activate([
            pointsLabel.leadingAnchor.constraint(equalTo: levelHeadlineLabel.leadingAnchor),
            pointsLabel.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 3),
            pointsLabel.trailingAnchor.constraint(equalTo: levelHeadlineLabel.trailingAnchor),
        ])
        self.blackBakcgroundView = CommonView.getViewWithShadowAndRadius(cornerRadius: 22)
        containerView.addSubview(blackBakcgroundView)
        self.blackBakcgroundView.backgroundColor = .black
        NSLayoutConstraint.activate([
            blackBakcgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blackBakcgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blackBakcgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blackBakcgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
        ])
    }
}
