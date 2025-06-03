//
//  LevelsAndCardsCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-20.
//

import UIKit

class LevelsAndCardsCell: UITableViewCell {
    
    let levelsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LearningResourceCell.self, forCellWithReuseIdentifier: "LearningResourceCell")
        return collectionView
    }()
    
    let cardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LearningResourceCell.self, forCellWithReuseIdentifier: "LearningResourceCell")
        return collectionView
    }()
    
    final var levelCellHeightAndWidth = 137.0
    final var cardCellHeightAndWidth = 100.0
    
    
    var selectedLevelIndex = 0
    var isSelectedLevelIndexChanged = false
    var cardDidTapped: ((_ selectedLevelIndex: Int, _ selectedCardIndex: Int) -> Void)?
    var gameLevels: [GameLevelModel]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setUpCell(gameLevels: [GameLevelModel]?)  {
        self.gameLevels = gameLevels
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        
        self.contentView.addSubview(levelsCollectionView)
        levelsCollectionView.delegate = self
        levelsCollectionView.dataSource = self
        levelsCollectionView.register(GameLevelCell.self, forCellWithReuseIdentifier: "GameLevelCell")
        NSLayoutConstraint.activate([
            levelsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            levelsCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            levelsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            levelsCollectionView.heightAnchor.constraint(equalToConstant: levelCellHeightAndWidth),
        ])
        self.contentView.addSubview(cardsCollectionView)
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsCollectionView.register(GameCardCell.self, forCellWithReuseIdentifier: "GameCardCell")
        NSLayoutConstraint.activate([
            cardsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            cardsCollectionView.topAnchor.constraint(equalTo: levelsCollectionView.bottomAnchor, constant: 15),
            cardsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            cardsCollectionView.heightAnchor.constraint(equalToConstant: cardCellHeightAndWidth * 2 + 10),
        ])
        cardsCollectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension LevelsAndCardsCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == levelsCollectionView ? gameLevels?.count ?? 0 : gameLevels?[selectedLevelIndex].cards.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var isCardLocked = false
        switch selectedLevelIndex {
        case 0:
            isCardLocked = (!isUserProMember() && indexPath.row >= 4)
            break
        case 1:
            isCardLocked = (!isUserProMember() && indexPath.row >= 3)
            break
        case 2:
            isCardLocked = (!isUserProMember() && indexPath.row >= 2)
            break
        case 3:
            isCardLocked = (!isUserProMember() && indexPath.row >= 1)
            break
        case 4:
            isCardLocked = (!isUserProMember() && indexPath.row >= 1)
            break
        case 5:
            isCardLocked = (!isUserProMember() && indexPath.row >= -1)
            break
        default:
            break
        }
        
        if collectionView == levelsCollectionView {
            
            let cell = levelsCollectionView.dequeueReusableCell(withReuseIdentifier: "GameLevelCell", for: indexPath) as! GameLevelCell
            cell.backgroundColor = .clear
            if let gameData = gameLevels?[indexPath.row] {
                cell.setupCell(levelData: gameData)
            }
            if selectedLevelIndex == indexPath.row {
                cell.containerView.transform = CGAffineTransform(scaleX: 1 , y: 1)
                cell.blackBakcgroundView.alpha = 0
            } else {
                cell.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                cell.blackBakcgroundView.alpha = 0.3
            }
            
            return cell
            
        } else {
            
            let cell = cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "GameCardCell", for: indexPath) as! GameCardCell
            cell.backgroundColor = .clear
            
            if let gameData = gameLevels?[selectedLevelIndex].cards[indexPath.row] {
                if let levelHealdline = gameLevels?[selectedLevelIndex].headline, levelHealdline == "GamesVC.LevelsAndPositionCardsHeader.level1.headlineLabel.text"~ {
                    let cardNumber = indexPath.row
                    cell.setupCell(index: indexPath.row, cardData: gameData, cardNumber: cardNumber, isCardLocked: isCardLocked)
                } else if let levelHealdline = gameLevels?[selectedLevelIndex].headline, levelHealdline == "GamesVC.LevelsAndPositionCardsHeader.level2.headlineLabel.text"~ {
                    let cardNumber = indexPath.row + ((gameLevels?[0].cards.count ?? 0))
                    cell.setupCell(index: indexPath.row, cardData: gameData, cardNumber: cardNumber, isCardLocked: isCardLocked)
                } else if let levelHealdline = gameLevels?[selectedLevelIndex].headline, levelHealdline == "GamesVC.LevelsAndPositionCardsHeader.level3.headlineLabel.text"~ {
                    let cardNumber = indexPath.row + ((gameLevels?[0].cards.count ?? 0)) + ((gameLevels?[1].cards.count ?? 0))
                    cell.setupCell(index: indexPath.row, cardData: gameData, cardNumber: cardNumber, isCardLocked: isCardLocked)
                } else{
                    cell.setupCell(index: indexPath.row, cardData: gameData, cardNumber: indexPath.row, isCardLocked: isCardLocked)
                }
            }
            
            if isCardLocked {
                cell.containerView.alpha = 0.5
            } else {
                cell.containerView.alpha = 1
            }
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == levelsCollectionView{
            return CGSize(width: levelCellHeightAndWidth + 30, height: levelCellHeightAndWidth)
        } else {
            return CGSize(width: cardCellHeightAndWidth, height: cardCellHeightAndWidth)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if collectionView == self.levelsCollectionView {
            cell?.showAnimation({
                if self.selectedLevelIndex == indexPath.row {
                    return
                }
                UIView.animate(withDuration: 0.15,
                               delay: 0.0,
                               options: .curveLinear,
                               animations: {
                    if let previousCell = collectionView.cellForItem(at: IndexPath(item: self.selectedLevelIndex, section: 0)) as? GameLevelCell {
                        previousCell.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        previousCell.blackBakcgroundView.alpha = 0.3
                    }
                    self.selectedLevelIndex = indexPath.row
                    if let currentCell = collectionView.cellForItem(at: IndexPath(item: self.selectedLevelIndex, section: 0)) as? GameLevelCell {
                        currentCell.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        currentCell.blackBakcgroundView.alpha = 0
                    }
                    self.isSelectedLevelIndexChanged = true
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
                        self.isSelectedLevelIndexChanged = false
                    }
                    self.cardsCollectionView.reloadData()
                })
            })
        } else {
            if let action = self.cardDidTapped {
                action(self.selectedLevelIndex, indexPath.row)
            }
        }
                
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == cardsCollectionView && self.isSelectedLevelIndexChanged {
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
