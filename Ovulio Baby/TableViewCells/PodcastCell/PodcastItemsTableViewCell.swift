//
//  PodcastItemsTableViewCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-08-26.
//

import UIKit

class PodcastItemsTableViewCell: UITableViewCell {
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PodcastItemCollectionViewCell.self, forCellWithReuseIdentifier: "PodcastItemCollectionViewCell")
        var index = 0
        return collectionView
    }()
    
    var podcastItemTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PodcastItemsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastItemCollectionViewCell", for: indexPath) as? PodcastItemCollectionViewCell else {
            fatalError("Unable to dequeue CustomCollectionViewCell")
        }
        cell.backgroundColor = .clear
        cell.label.text = "Recording Title with description \(indexPath.item + 1)"
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150.pulseWithFont(withInt: 20), height: 210.pulseWithFont(withInt: 20))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let action = podcastItemTapped {
            action()
        }
    }
}
