//
//  TrackFertilityOnBoardingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-24.
//

import UIKit

class TrackFertilityOnBoardingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bottomImageView = CommonView.getCommonImageView(image: "TrackFertilityOnBoardingVCIMG")
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.contentMode = .scaleAspectFit
        self.view.addSubview(bottomImageView)
        NSLayoutConstraint.activate([
            bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            bottomImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
            bottomImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: ScreenSize.height * 0.0006)
        ])
        
        let headlineLabel = CommonView.getCommonLabel(text: "TrackFertilityOnBoardingVC.headlineLabel.text"~, font: .boldSystemFont(ofSize: DeviceSize.fontFor26), lines: 0, alignment: .center)
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DeviceSize.onbordingContentTopPadding),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
        ])
        
        let headlineDescriptionLabel = CommonView.getCommonLabel(text: "TrackFertilityOnBoardingVC.headlineDescriptionLabel.text"~, font: .systemFont(ofSize: DeviceSize.fontFor14), lines: 0, alignment: .center)
        self.view.addSubview(headlineDescriptionLabel)
        NSLayoutConstraint.activate([
            headlineDescriptionLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor, constant: 10),
            headlineDescriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 15),
            headlineDescriptionLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor, constant: -10),
        ])
    }
}
