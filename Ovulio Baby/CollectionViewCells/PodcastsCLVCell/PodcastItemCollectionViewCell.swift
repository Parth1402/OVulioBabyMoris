//
//  PodcastItemCollectionViewCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-08-26.
//

import UIKit

class PodcastItemCollectionViewCell: UICollectionViewCell {
    
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = .clear
        cellView.layer.cornerRadius = 13
        cellView.clipsToBounds = true
        cellView.setGradientBackground(colorTop: "#FF7A9F", colorBotom: "#B660DE")
        return cellView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .mymediumSystemFont(ofSize: 14.pulse2Font())
        label.textColor = appColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headphoneIMGView: UIButton = {
        let headphoneIMGView = UIButton()
        headphoneIMGView.translatesAutoresizingMaskIntoConstraints = false
        headphoneIMGView.setImage(UIImage(named: "headphonePodcastIMG"), for: .normal)
        return headphoneIMGView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(cellView)
        contentView.addSubview(label)
        contentView.addSubview(headphoneIMGView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            cellView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.7),
            
            label.topAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            headphoneIMGView.heightAnchor.constraint(equalToConstant: 22),
            headphoneIMGView.widthAnchor.constraint(equalToConstant: 22),
            headphoneIMGView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor,constant: -8),
            headphoneIMGView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor,constant: -8)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        cellView.setGradientBackground(colorTop: "#FF7A9F", colorBotom: "#B660DE")
    }
}

extension UIView {
    func addDashBorder() {
        let color = UIColor.systemBlue.cgColor
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineDashPattern = [6, 6]
        shapeLayer.fillColor = nil
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func setGradientBackground(colorTop:String, colorBotom:String) {
        // Convert hexadecimal color values to UIColor
        guard let colorTop = UIColor(hex: colorTop)?.cgColor,
              let colorBottom = UIColor(hex: colorBotom)?.cgColor else {
            return
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
