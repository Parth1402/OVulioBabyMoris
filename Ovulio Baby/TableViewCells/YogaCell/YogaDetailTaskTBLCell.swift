//
//  YogaDetailTaskTBLCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-03-20.
//

import UIKit

class YogaDetailTaskTBLCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell(detailHeadlineText: String, detailSubtitleText: String) {
        self.contentView.backgroundColor = .clear
        let detailHeadline = CommonView.getCommonLabel(text: detailHeadlineText, textColor: girlAppColor, font: .boldSystemFont(ofSize: 16.pulse2Font()))
        self.contentView.addSubview(detailHeadline)
        NSLayoutConstraint.activate([
            detailHeadline.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            detailHeadline.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            detailHeadline.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
        ])
        
        let detailSubtitle = CommonView.getCommonLabel(text: detailSubtitleText, font: .systemFont(ofSize: 14.pulse2Font()), lines: 0)
        self.contentView.addSubview(detailSubtitle)
        NSLayoutConstraint.activate([
            detailSubtitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            detailSubtitle.topAnchor.constraint(equalTo: detailHeadline.bottomAnchor, constant: 10),
            detailSubtitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            detailSubtitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
        ])
    }

}
