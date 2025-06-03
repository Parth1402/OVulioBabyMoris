//
//  FavouriteNameTableViewCell.swift
//  Ovulio Baby
//
//  Created by USER on 14/04/25.
//

import UIKit
import AlignedCollectionViewFlowLayout


class FavouriteNameTableViewCell: UITableViewCell {
    
    private var  stylelengthArray = [String]()
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    var SelectedCell = IndexPath()
    
    private let buttonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false // ⛔ Important: Disable scrolling
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
//    private let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 8
//        layout.minimumLineSpacing = 8
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.scrollDirection = .vertical
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.isScrollEnabled = false
//        collectionView.backgroundColor = .clear
//        return collectionView
//    }()

    
    
    var isFieldChanged: ((IndexPath) -> Void)?
    
    private var selectedIndex: IndexPath?
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(buttonContainerView)
        buttonContainerView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavouriteNameCollectionCell.self, forCellWithReuseIdentifier: "FavouriteNameCollectionCell")
        
        NSLayoutConstraint.activate([
            
            buttonContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            collectionView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 120)
        collectionViewHeightConstraint?.isActive = true
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        collectionView.layoutIfNeeded()
    //        collectionViewHeightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    //        self.invalidateIntrinsicContentSize()
    //
    //    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }
    
    private func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        collectionViewHeightConstraint?.constant = contentSize.height
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    
    func configure(withTitle title: String, Array: [String]) {
        stylelengthArray = Array
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.updateCollectionViewHeight()
        }
    }
}

// MARK: - UICollectionViewDelegate, DataSource

extension FavouriteNameTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stylelengthArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteNameCollectionCell", for: indexPath) as? FavouriteNameCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.closeButton.tag = indexPath.item
        let title = stylelengthArray[indexPath.item]
        cell.setupUI(headlineTitle: title)
        
        // cell.setSelectedAppearance(selectedIndex == indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedIndex
        selectedIndex = indexPath
        
        // Reload only the changed cells
        var indexPathsToReload = [indexPath]
        if let previous = previousIndex, previous != indexPath {
            indexPathsToReload.append(previous)
        }
        
        let indexp = IndexPath(item: indexPath.item, section: SelectedCell.section)
        isFieldChanged?(indexp)
        collectionView.reloadItems(at: [indexPath])
        
        // Update height if needed
        DispatchQueue.main.async {
            self.collectionView.layoutIfNeeded()
            let newHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            if self.collectionViewHeightConstraint?.constant != newHeight {
                self.collectionViewHeightConstraint?.constant = newHeight
                self.invalidateIntrinsicContentSize()
            }
        }
    }
}
