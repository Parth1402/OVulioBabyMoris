//
//  SlsGameSelectBodyPartsTableViewCells.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 01.09.22.
//

import Foundation
import UIKit


class SlsGameSelectBodyPartsTableViewCells: UITableViewCell {
    
    let cellBackground: UIView = {
        
        let backgroundCell = UIView()
        backgroundCell.backgroundColor = UIColor.white
        backgroundCell.clipsToBounds = false
        backgroundCell.layer.cornerRadius = 12.0
        
        return backgroundCell
        
    }()
    
    
    let checkButton: UIButton = {
        
        let buttonCheck = UIButton()
        buttonCheck.backgroundColor = UIColor.white
        //buttonCheck.setImage(UIImage(named: "Onboarding Page Legal Text Check Box not clicked"), for: .normal)
        
        return buttonCheck
        
    }()
    
    
    let headlineLabel: UILabel = {
        
        let cellLabel = UILabel()
        cellLabel.backgroundColor = UIColor.clear
        cellLabel.font = .systemFont(ofSize: 16)
        cellLabel.textColor = appColor
        cellLabel.adjustsFontSizeToFitWidth = true
        cellLabel.textAlignment = .left
        
        return cellLabel
        
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let menuWidth = UIScreen.main.bounds.width * 0.9  //var menuWidth = UIScreen.main.bounds.width * 0.75
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            print("Device is iPad")
            //menuWidth = 280.0
        }
        
        self.addSubview(cellBackground)
        cellBackground.translatesAutoresizingMaskIntoConstraints = false
        cellBackground.heightAnchor.constraint(equalToConstant: 52.0).isActive = true
        cellBackground.widthAnchor.constraint(equalToConstant: menuWidth).isActive = true
        cellBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        cellBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        /*
        cellBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 6.0).isActive = true
        cellBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6.0).isActive = true
        cellBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0).isActive = true
        cellBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0).isActive = true
        */
        
        
        self.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.rightAnchor.constraint(equalTo: self.cellBackground.rightAnchor, constant: -10.0).isActive = true
        checkButton.centerYAnchor.constraint(equalTo: self.cellBackground.centerYAnchor, constant: 0.0).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        
        checkButton.layer.cornerRadius = 11.0
        
        
        
        self.addSubview(headlineLabel)
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.topAnchor.constraint(equalTo: self.cellBackground.topAnchor, constant: 2.0).isActive = true
        headlineLabel.bottomAnchor.constraint(equalTo: self.cellBackground.bottomAnchor, constant: -2.0).isActive = true
        headlineLabel.leftAnchor.constraint(equalTo: self.cellBackground.leftAnchor, constant: 10.0).isActive = true
        headlineLabel.rightAnchor.constraint(equalTo: self.checkButton.leftAnchor, constant: -6.0).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
