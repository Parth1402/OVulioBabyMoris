//
//  SalesPlanCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-28.
//

import UIKit

class SalesPlanCell: UICollectionViewCell {
    
    var viewPopular: UIView!
    var planContainer: UIView!
    var headlineLabel: UILabel!
    var durationContainer: UIView!
    var priceContainer: UIView!
    let pinkWhite = UIColor(hexString: "FFF2F2") ?? .white
    let lightBlue = UIColor(hexString: "AA97BD") ?? appColor
    let lightPinkAppColor = UIColor(hexString: "FF76B7") ?? girlAppColor
    
    override func prepareForReuse() {
        if viewPopular != nil{
            viewPopular.removeFromSuperview()
        }
        planContainer.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(data: PlansModel) {
        if data.headline != "" {
            viewPopular = UIView()
            viewPopular.backgroundColor = lightBlue
            viewPopular.clipsToBounds = true
            viewPopular.layer.cornerRadius = 10
            viewPopular.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            viewPopular.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(viewPopular)
            NSLayoutConstraint.activate([
                viewPopular.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
                viewPopular.topAnchor.constraint(equalTo: contentView.topAnchor),
                viewPopular.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
                viewPopular.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
        
        planContainer = UIView()
        planContainer.backgroundColor = data.isSelected ? lightPinkAppColor : .clear
        planContainer.layer.cornerRadius = 10
        planContainer.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(planContainer)
        NSLayoutConstraint.activate([
            planContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            planContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            planContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            planContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
        headlineLabel = CommonView.getCommonLabel(text: data.headline, textColor: .white, font: .mymediumSystemFont(ofSize: 15.pulse2Font()), alignment: .center)
        headlineLabel.adjustsFontSizeToFitWidth = true
        headlineLabel.minimumScaleFactor = 0.2
        self.planContainer.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: planContainer.leadingAnchor),
            headlineLabel.topAnchor.constraint(equalTo: planContainer.topAnchor, constant: 5),
            headlineLabel.trailingAnchor.constraint(equalTo: planContainer.trailingAnchor),
            headlineLabel.heightAnchor.constraint(equalToConstant: 20.pulse())
        ])
        
        durationContainer = UIView()
        durationContainer.backgroundColor = pinkWhite
        durationContainer.clipsToBounds = true
        durationContainer.layer.cornerRadius = 10
        durationContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        durationContainer.translatesAutoresizingMaskIntoConstraints = false
        self.planContainer.addSubview(durationContainer)
        NSLayoutConstraint.activate([
            durationContainer.leadingAnchor.constraint(equalTo: self.planContainer.leadingAnchor, constant: 3),
            durationContainer.topAnchor.constraint(equalTo: self.headlineLabel.bottomAnchor, constant: 5),
            durationContainer.trailingAnchor.constraint(equalTo: self.planContainer.trailingAnchor, constant: -3),
            durationContainer.heightAnchor.constraint(equalToConstant: 75.pulse(20))
        ])
        
        let durationLabel = CommonView.getCommonLabel(text: data.duration, font: .mymediumSystemFont(ofSize: 16.pulse2Font()), alignment: .center)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.adjustsFontSizeToFitWidth = true
        durationLabel.minimumScaleFactor = 0.2
        durationContainer.addSubview(durationLabel)
        NSLayoutConstraint.activate([
            durationLabel.leadingAnchor.constraint(equalTo: durationContainer.leadingAnchor),
            durationLabel.topAnchor.constraint(equalTo: durationContainer.topAnchor, constant: 12),
            durationLabel.trailingAnchor.constraint(equalTo: durationContainer.trailingAnchor),
        ])
        
        let durationDetailLabel = CommonView.getCommonLabel(text: data.durationDetails, textColor: lightBlue, font: .systemFont(ofSize: 13.pulse2Font()), lines: 2, alignment: .center)
        durationDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        durationDetailLabel.adjustsFontSizeToFitWidth = true
        durationDetailLabel.minimumScaleFactor = 0.2
        durationContainer.addSubview(durationDetailLabel)
        NSLayoutConstraint.activate([
            durationDetailLabel.leadingAnchor.constraint(equalTo: durationContainer.leadingAnchor),
            durationDetailLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 2),
            durationDetailLabel.trailingAnchor.constraint(equalTo: durationContainer.trailingAnchor),
            durationDetailLabel.bottomAnchor.constraint(lessThanOrEqualTo: durationContainer.bottomAnchor, constant: 5)
        ])
        if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == false && data.subscriptionType != "weekly" {  // weekly, monthly, 3months
            durationDetailLabel.font = .boldSystemFont(ofSize: 14.pulse2Font())
        }
        
        priceContainer = UIView()
        priceContainer.backgroundColor = pinkWhite
        priceContainer.clipsToBounds = true
        priceContainer.layer.cornerRadius = 10
        priceContainer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        priceContainer.translatesAutoresizingMaskIntoConstraints = false
        self.planContainer.addSubview(priceContainer)
        NSLayoutConstraint.activate([
            priceContainer.leadingAnchor.constraint(equalTo: self.planContainer.leadingAnchor, constant: 3),
            priceContainer.topAnchor.constraint(equalTo: self.durationContainer.bottomAnchor, constant: 3),
            priceContainer.trailingAnchor.constraint(equalTo: self.planContainer.trailingAnchor, constant: -3),
            priceContainer.heightAnchor.constraint(equalToConstant: 120.pulse(13))
        ])
        
        let beforePriceLabel = CommonView.getCommonLabel(text: data.beforePrice, textColor: lightBlue, font: .systemFont(ofSize: 13.pulse2Font()), lines: 2, alignment: .center)
        beforePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        beforePriceLabel.adjustsFontSizeToFitWidth = true
        beforePriceLabel.minimumScaleFactor = 0.2
        let attributedString = NSAttributedString(string: beforePriceLabel.text ?? "",
                                                  attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        beforePriceLabel.attributedText = attributedString
        priceContainer.addSubview(beforePriceLabel)
        NSLayoutConstraint.activate([
            beforePriceLabel.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor),
            beforePriceLabel.topAnchor.constraint(equalTo: priceContainer.topAnchor, constant: 12),
            beforePriceLabel.trailingAnchor.constraint(equalTo: priceContainer.trailingAnchor),
        ])
        if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == false && data.subscriptionType != "weekly" {  // weekly, monthly, 3months
            beforePriceLabel.isHidden = true
        } else {
            beforePriceLabel.isHidden = false
        }
        if data.beforePrice == "0"{
            beforePriceLabel.isHidden = true
        }
        
        let priceLabel = CommonView.getCommonLabel(text: data.price, font: .mymediumSystemFont(ofSize: 16.pulse2Font()), alignment: .center)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.2
        priceContainer.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: beforePriceLabel.bottomAnchor, constant: 6),
            priceLabel.trailingAnchor.constraint(equalTo: priceContainer.trailingAnchor),
        ])
        if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == false && data.subscriptionType != "weekly" {  // weekly, monthly, 3months
            priceLabel.isHidden = true
        } else {
            priceLabel.isHidden = false
        }
        
        let priceDetailLabel = CommonView.getCommonLabel(text: data.priceDetails, font: .systemFont(ofSize: 13.pulse2Font()), lines: 2, alignment: .center)
        priceDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        priceDetailLabel.adjustsFontSizeToFitWidth = true
        priceDetailLabel.minimumScaleFactor = 0.2
        priceContainer.addSubview(priceDetailLabel)
        NSLayoutConstraint.activate([
            priceDetailLabel.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor),
            priceDetailLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0),
            priceDetailLabel.trailingAnchor.constraint(equalTo: priceContainer.trailingAnchor),
        ])
        if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == false && data.subscriptionType != "weekly" {  // weekly, monthly, 3months
            priceDetailLabel.isHidden = true
        } else {
            priceDetailLabel.isHidden = false
        }
        
        let discountLabel = CommonView.getCommonLabel(text: data.discount, textColor: UIColor(hexString: "F79E1A") ?? .yellow, font: .mymediumSystemFont(ofSize: 17.pulse2Font()), alignment: .center)
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        discountLabel.adjustsFontSizeToFitWidth = true
        discountLabel.minimumScaleFactor = 0.2
        priceContainer.addSubview(discountLabel)
        NSLayoutConstraint.activate([
            discountLabel.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor),
            discountLabel.topAnchor.constraint(equalTo: priceDetailLabel.bottomAnchor, constant: 6),
            discountLabel.trailingAnchor.constraint(equalTo: priceContainer.trailingAnchor)
        ])
        
    }
    
}
