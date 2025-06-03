//
//  GameCardCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-20.
//

import UIKit

class GameCardCell: UICollectionViewCell {
    var containerView = UIView()
    override func prepareForReuse() {
        containerView.removeFromSuperview()
    }
    
    func setupCell(index: Int, cardData: ScrachCardModel, cardNumber: Int, isCardLocked: Bool) {
        self.containerView = CommonView.getViewWithShadowAndRadius(cornerRadius: 50)
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ])
        let gredientCardImageView = CommonView.getCommonImageView(image: cardData.isAlreadyScrached ? cardData.cardImage : "positionCardGredientIMG", cornerRadius: 50)
        gredientCardImageView.clipsToBounds = true
        gredientCardImageView.hero.id = "gredientCardImageHeroID\(index)"
        containerView.addSubview(gredientCardImageView)
        NSLayoutConstraint.activate([
            gredientCardImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gredientCardImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gredientCardImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gredientCardImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
        ])
        
        if isCardLocked {
            let cardLocalImage = CommonView.getCommonImageView(image: "Card Lock Icon")
            cardLocalImage.alpha = 0.10
            cardLocalImage.contentMode = .scaleAspectFill
            containerView.addSubview(cardLocalImage)
            NSLayoutConstraint.activate([
                cardLocalImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                cardLocalImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -3),
                cardLocalImage.widthAnchor.constraint(equalToConstant: 25),
                cardLocalImage.heightAnchor.constraint(equalToConstant: 25),
            ])
        }
        if cardData.isAlreadyScrached {
            gredientCardImageView.image = UIImage(named: cardData.cardImage)
        }else{
            let cardNumberLabel = CommonView.getCommonLabel(text: "\(cardNumber + 1)", textColor: .white, font: .boldSystemFont(ofSize: 20.pulse2Font()), alignment: .center)
            containerView.addSubview(cardNumberLabel)
            NSLayoutConstraint.activate([
                cardNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                cardNumberLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                cardNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                cardNumberLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            ])
        }
        
    }
}
