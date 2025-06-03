//
//  ArticleDetailTextCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-13.
//

import UIKit

class ArticleDetailTextCell: UITableViewCell {
    
    let atricleTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var gradientView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        atricleTextLabel.removeFromSuperview()
        gradientView.removeFromSuperview()
    }
    
    func seuUpCell(text: String, showBlurView: Bool = false) {
        self.contentView.addSubview(atricleTextLabel)
        atricleTextLabel.text = text
        NSLayoutConstraint.activate([
            atricleTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            atricleTextLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            atricleTextLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            atricleTextLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func setupGradientView(colors: [CGColor]) {
        gradientView = UIView()
        gradientView.backgroundColor = .white.withAlphaComponent(0.5)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(gradientView)
        
        gradientView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        gradientView.updateFocusIfNeeded()
        gradientView.layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update gradient layer frame when the cell's layout changes
        gradientView.layer.sublayers?.first?.frame = gradientView.bounds
    }
}
