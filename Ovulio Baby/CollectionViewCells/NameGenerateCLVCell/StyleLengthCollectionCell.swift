//
//  StyleLengthCollectionCell.swift
//  Ovulio Baby
//
//  Created by USER on 09/04/25.
//

import UIKit

//class StyleLengthCollectionCell: UICollectionViewCell {
//    
//    let buttonContainerView: UIView = {
//        let buttonContainerView = UIView()
//        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
//        return buttonContainerView
//    }()
//    
//    let boyBorderView = UIView()
//    let boyContainerView = UIView()
//    
//    let allSpacingForButtons = 40.0
//    let buttonViewHeight = DeviceSize.isiPadDevice ? 135.0 : 120.0
//    
//    
//    func setupUI(headlineTitle: String) {
//    
//        contentView.addSubview(buttonContainerView)
//        NSLayoutConstraint.activate([
//            buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            buttonContainerView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
//            buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            buttonContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
//        ])
//        makeBoyGoalView(name: headlineTitle)
//    }
//    
//    
//}
//
//// MARK: Goal Button Views
//extension StyleLengthCollectionCell {
//    
//    func makeBoyGoalView(name:String) {
//        boyContainerView.backgroundColor = .clear
//        buttonContainerView.addSubview(boyContainerView)
//        boyContainerView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            boyContainerView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
//            boyContainerView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 15),
//            boyContainerView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.33),
//            boyContainerView.heightAnchor.constraint(equalToConstant: buttonViewHeight),
//            boyContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
//        ])
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
//        boyContainerView.tag = 1
//        boyContainerView.addGestureRecognizer(tapGesture)
//        
//        boyBorderView.backgroundColor = .white
//        boyContainerView.addSubview(boyBorderView)
//        boyBorderView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            boyBorderView.centerXAnchor.constraint(equalTo: boyContainerView.centerXAnchor),
//            boyBorderView.bottomAnchor.constraint(equalTo: boyContainerView.bottomAnchor),
//            boyBorderView.widthAnchor.constraint(equalToConstant: (((DeviceSize.isiPadDevice ? 460 : ScreenSize.width) - allSpacingForButtons) * 0.33) - 8),
//            boyBorderView.heightAnchor.constraint(equalToConstant: (buttonViewHeight - 40))
//        ])
//        boyBorderView.layer.cornerRadius = 20
//        boyBorderView.clipsToBounds = true
//        boyBorderView.layer.borderWidth = ProfileDataManager.shared.selectedGender == .boy ? 2 : 0
//        boyBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
//        boyBorderView.dropShadow()
//        
//        
//        let boyLabel = UILabel()
//        boyLabel.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
//        boyLabel.text = name~
//        boyLabel.textAlignment = .center
//        boyLabel.textColor = appColor
//        boyBorderView.addSubview(boyLabel)
//        boyLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            boyLabel.leadingAnchor.constraint(equalTo: boyBorderView.leadingAnchor),
//            boyLabel.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: 20),
//            boyLabel.trailingAnchor.constraint(equalTo: boyBorderView.trailingAnchor),
//            boyLabel.bottomAnchor.constraint(equalTo: boyBorderView.bottomAnchor),
//        ])
//    }
//}
//
// MARK: Actions
//extension StyleLengthCollectionCell {
//    
//    @objc func handleGoalSelection(_ sender: UITapGestureRecognizer) {
//        self.contentView.superview?.superview?.endEditing(true)
//        if let buttonTag = sender.view?.tag {
//         
//            
//        }
//    }
//}
//
//
class StyleLengthCollectionCell: UICollectionViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = appColor
        label.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.clipsToBounds = true
        contentView.dropShadow()
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
    }


    func setupUI(headlineTitle: String) {
        titleLabel.text = headlineTitle
    }
    func setSelectedAppearance(_ selected: Bool) {
        if selected {
            contentView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
            contentView.layer.borderWidth = 2
            contentView.dropShadow()
        } else {
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0
            contentView.dropShadow()
        }
    }
}


//class StyleLengthCollectionCell: UICollectionViewCell {
//    
//    private let buttonContainerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let boyBorderView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 8
//        view.clipsToBounds = true
//        view.layer.borderWidth = 0
//        view.layer.borderColor = UIColor.clear.cgColor
//        view.dropShadow()
//        return view
//    }()
//    
//    private let boyLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
//        label.textAlignment = .center
//        label.textColor = appColor
//        label.numberOfLines = 2
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCell()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupCell() {
//        contentView.backgroundColor = .clear
//        contentView.addSubview(buttonContainerView)
//        
//        NSLayoutConstraint.activate([
//            buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            buttonContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            buttonContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        ])
//        
//        buttonContainerView.addSubview(boyBorderView)
//        NSLayoutConstraint.activate([
//            boyBorderView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 0),
//            boyBorderView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 0),
//            boyBorderView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: 0),
//            boyBorderView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor, constant: 0),
//        ])
//        
//        boyBorderView.addSubview(boyLabel)
//        NSLayoutConstraint.activate([
//            boyLabel.leadingAnchor.constraint(equalTo: boyBorderView.leadingAnchor, constant: 8),
//            boyLabel.trailingAnchor.constraint(equalTo: boyBorderView.trailingAnchor, constant: -8),
//            boyLabel.centerYAnchor.constraint(equalTo: boyBorderView.centerYAnchor),
//        ])
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
//        boyBorderView.addGestureRecognizer(tapGesture)
//        boyBorderView.isUserInteractionEnabled = true
//    }
//    
//    func setupUI(headlineTitle: String) {
//        boyLabel.text = headlineTitle
//    }
//
//    func setSelectedAppearance(_ selected: Bool) {
//        boyBorderView.layer.borderWidth = selected ? 2 : 0
//        boyBorderView.layer.borderColor = selected ? UIColor(hexString: "AA97BD")?.cgColor : UIColor.clear.cgColor
//    }
//    
//    @objc private func handleGoalSelection() {
//        print("Tapped on: \(boyLabel.text ?? "")")
//    }
//}
