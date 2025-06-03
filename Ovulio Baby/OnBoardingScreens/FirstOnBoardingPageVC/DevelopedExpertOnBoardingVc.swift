//
//  DevelopedExpertOnBoardingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-25.
//

import UIKit

class DevelopedExpertOnBoardingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let headlineLabel = CommonView.getCommonLabel(text: "DevelopedExpertOnBoardingVc.headlineLabel.text"~, font: .boldSystemFont(ofSize: DeviceSize.fontFor26), lines: 0, alignment: .center)
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DeviceSize.onbordingContentTopPadding),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
        ])
        
        let headlineDescriptionLabel = CommonView.getCommonLabel(text: "DevelopedExpertOnBoardingVc.headlineDescriptionLabel.text"~, font: .systemFont(ofSize: DeviceSize.fontFor14), lines: 0, alignment: .center)
        self.view.addSubview(headlineDescriptionLabel)
        NSLayoutConstraint.activate([
            headlineDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            headlineDescriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 15),
            headlineDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
        ])
        
        let bottomImageView = CommonView.getCommonImageView(image: "DevelopedExpertOnBoardingVcIMG")
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.contentMode = .scaleAspectFit
        self.view.addSubview(bottomImageView)
        NSLayoutConstraint.activate([
            bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            bottomImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
            bottomImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        let expertNameHeadlineLabel = CommonView.getCommonLabel(text: "DevelopedExpertOnBoardingVc.ExpertName.headlineLabel.text"~, textColor: lightAppColor, font: .mymediumSystemFont(ofSize: DeviceSize.fontFor15), lines: 0, alignment: .center)
        self.view.addSubview(expertNameHeadlineLabel)
        NSLayoutConstraint.activate([
            expertNameHeadlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            expertNameHeadlineLabel.topAnchor.constraint(equalTo: bottomImageView.bottomAnchor, constant: 5),
            expertNameHeadlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
        ])
    }
}
