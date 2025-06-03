import UIKit
import AlignedCollectionViewFlowLayout


class FavouriteNameTableViewCell: UITableViewCell {
    
    private var  stylelengthArray = [String]()
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    var SelectedCell = 0
    
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
        
        // Handle close button tap
        cell.closeButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            // Animate the deletion
            UIView.animate(withDuration: 0.2, animations: {
                cell.alpha = 0
                cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { _ in
                // Remove the item from the array
                self.stylelengthArray.remove(at: indexPath.item)
                
                // Update collection view
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: [indexPath])
                }, completion: { _ in
                    // Update layout after deletion
                    DispatchQueue.main.async {
                        self.updateCollectionViewHeight()
                    }
                    
                    // Notify the delegate
                    self.isFieldChanged?(IndexPath(item: indexPath.item, section: self.SelectedCell))
                })
            })
        }
        
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

        // Reload only affected items in a batch (like begin/end updates)
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: indexPathsToReload)
        }

        // Trigger the external callback if needed
        isFieldChanged?(IndexPath(item: indexPath.item, section: SelectedCell))

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