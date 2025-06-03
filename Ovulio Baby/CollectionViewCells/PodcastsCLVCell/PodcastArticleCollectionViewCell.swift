//
//  PodcastArticleCollectionViewCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-08-26.
//

import UIKit

class PodcastArticleCollectionViewCell: UICollectionViewCell {
    
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = .systemPink
        cellView.layer.cornerRadius = 15
        return cellView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let Desclabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //   addSubview(topLabel)
        contentView.backgroundColor = .clear
        contentView.addSubview(cellView)
        contentView.addSubview(label)
        contentView.addSubview(Desclabel)
        contentView.addSubview(imgView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: -8),
            
            Desclabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            Desclabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            Desclabel.trailingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: -8),
            
            
            imgView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            imgView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8),
            imgView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -8),
            imgView.widthAnchor.constraint(equalToConstant: 140),
            
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
