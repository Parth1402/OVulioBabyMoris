//
//  InfluenceGenderOnBoardingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-25.
//

import UIKit

class InfluenceGenderOnBoardingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomImageView = CommonView.getCommonImageView(image: "InfluenceGenderOnBoardingVCIMG")
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.contentMode = .scaleAspectFit
        self.view.addSubview(bottomImageView)
        NSLayoutConstraint.activate([
            bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            bottomImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
            bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
            bottomImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: ScreenSize.height * 0.0006)
        ])
        
        let headlineLabel = CommonView.getCommonLabel(text: "InfluenceGenderOnBoardingVC.headlineLabel.text"~, font: .boldSystemFont(ofSize: DeviceSize.fontFor26), lines: 0, alignment: .center)
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DeviceSize.onbordingContentTopPadding),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
        ])
        
        let headlineDescriptionLabel = CommonView.getCommonLabel(text: "InfluenceGenderOnBoardingVC.headlineDescriptionLabel.text"~, font: .systemFont(ofSize: DeviceSize.fontFor14), lines: 0, alignment: .center)
        self.view.addSubview(headlineDescriptionLabel)
        NSLayoutConstraint.activate([
            headlineDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            headlineDescriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 15),
            headlineDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
        ])
    }
}
