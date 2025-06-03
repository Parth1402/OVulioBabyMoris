//
//  ChooseStyleLengthSelectionCell.swift
//  Ovulio Baby
//
//  Created by USER on 09/04/25.
//

import UIKit
import AlignedCollectionViewFlowLayout
import AudioToolbox

class ChooseStyleLengthSelectionCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private var  stylelengthArray = [String]()
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    var SelectedCell = 0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = appColor
        label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
        return label
    }()
    
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
    
    
    var isFieldChanged: (() -> Void)?
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonContainerView)
        buttonContainerView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StyleLengthCollectionCell.self, forCellWithReuseIdentifier: "StyleLengthCollectionCell")
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 20 : 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            buttonContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            // collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionViewHeightConstraint?.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.layoutIfNeeded()
        collectionViewHeightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }


    func configure(withTitle title: String, Array array: [String]) {
        self.titleLabel.text = title
        self.stylelengthArray = array
        collectionView.reloadData()
        
        // Ensures collectionView height updates after data reload
        DispatchQueue.main.async {
            self.collectionView.layoutIfNeeded()
            self.collectionViewHeightConstraint?.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.invalidateIntrinsicContentSize()
            
//            // Important if your cell uses automatic height
//            self.superview?.setNeedsLayout()
//            self.superview?.layoutIfNeeded()
        }
    }
    
}

// MARK: - UICollectionViewDelegate, DataSource

extension ChooseStyleLengthSelectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stylelengthArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StyleLengthCollectionCell", for: indexPath) as? StyleLengthCollectionCell else {
            return UICollectionViewCell()
        }
        
        let title = stylelengthArray[indexPath.item]
        cell.setupUI(headlineTitle: title)
        
        cell.setSelectedAppearance(selectedIndex == indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        let previousIndex = selectedIndex
        selectedIndex = indexPath
        
        // Reload previous and current cells to update UI
        var indexPathsToReload = [indexPath]
        if let previous = previousIndex, previous != indexPath {
            indexPathsToReload.append(previous)
        }
        
        let title = stylelengthArray[indexPath.item]
        
        if SelectedCell == 0 {
            NameGenerateDataBeforeSaving.ChooseStyle = title
            NameGenerateDataBeforeSaving.isChooseStyle = true
            
            if let action = self.isFieldChanged {
                action()
            }
        }else {
            NameGenerateDataBeforeSaving.ChooseLength = title
            NameGenerateDataBeforeSaving.isChooseLength = true
            
            if let action = self.isFieldChanged {
                action()
            }
            
        }
        collectionView.reloadItems(at: indexPathsToReload)
    }
}

