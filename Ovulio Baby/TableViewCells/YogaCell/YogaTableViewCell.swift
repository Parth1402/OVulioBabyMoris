//
//  YogaTableViewCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-03-18.
//

import UIKit

class YogaTableViewCell: UITableViewCell {

    var yogaFertilityData = [YogaFertilityPositionModel]()
    let fertilityDescriptionLabel = CommonView.getCommonLabel(text: "YogaVC.FertilityPositions.headlineDescriptionLabel.text"~, lines: 0)
    let yogaCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    var yogaCardDidTapped: ((_ selectedCardIndex: Int) -> Void)?
    var cardWidth = DeviceSize.isiPadDevice ? ((ScreenSize.width - 40) / 5) : ((ScreenSize.width - 40) / 3)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell() {
        setUpTopView()
        setUpCollectionView()
    }
    
    func setUpTopView() {
        contentView.addSubview(fertilityDescriptionLabel)
        NSLayoutConstraint.activate([
            fertilityDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fertilityDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            fertilityDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    func setUpCollectionView() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(yogaCardsCollectionView)
        yogaCardsCollectionView.delegate = self
        yogaCardsCollectionView.dataSource = self
        yogaCardsCollectionView.register(YogaCardCLVCell.self, forCellWithReuseIdentifier: "YogaCardCLVCell")
        NSLayoutConstraint.activate([
            yogaCardsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            yogaCardsCollectionView.topAnchor.constraint(equalTo: fertilityDescriptionLabel.bottomAnchor, constant: 15),
            yogaCardsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            yogaCardsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            yogaCardsCollectionView.heightAnchor.constraint(equalToConstant: cardWidth * (ceil(CGFloat(yogaFertilityData.count) / 3.0))),
        ])
        yogaCardsCollectionView.reloadData()
    }

}


// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension YogaTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yogaFertilityData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = yogaCardsCollectionView.dequeueReusableCell(withReuseIdentifier: "YogaCardCLVCell", for: indexPath) as! YogaCardCLVCell
            cell.backgroundColor = .clear
        cell.setupCell(index: indexPath.row, cardData: ScrachCardModel(cardImage: yogaFertilityData[indexPath.row].images[0], probability: .boy, isAlreadyScrached: yogaFertilityData[indexPath.row].isScratched), cardNumber: indexPath.row, isCardLocked: false)
            
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: cardWidth - 4, height: cardWidth - 5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        if let action = self.yogaCardDidTapped {
            action(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == yogaCardsCollectionView {
            cell.contentView.alpha = 0.0
            if indexPath.row % (Int.random(in: 2..<6)) == Int.random(in: 0..<1) {
                cell.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
                    cell.contentView.transform = .identity
                    cell.contentView.alpha = 1
                })
            }else {
                UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveLinear, animations: { () -> Void in
                    cell.contentView.alpha = 1
                })
            }
        }
        
    }
}
