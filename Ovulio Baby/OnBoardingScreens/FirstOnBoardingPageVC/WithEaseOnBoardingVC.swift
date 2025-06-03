//
//  WithEaseOnBoardingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-24.
//

import UIKit

class WithEaseOnBoardingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headlineLabel = CommonView.getCommonLabel(text: "WithEaseOnBoardingVC.headlineLabel.text"~, font: .boldSystemFont(ofSize: DeviceSize.fontFor26), lines: 0, alignment: .center)
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DeviceSize.onbordingContentTopPadding),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
        ])
        
        let bottomBackgroundImageView = CommonView.getCommonImageView(image: "WithEaseOnBoardingVCIMG")
        bottomBackgroundImageView.contentMode = .scaleAspectFit
        bottomBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBackgroundImageView)
        NSLayoutConstraint.activate([
            bottomBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            bottomBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.heightOfView * 0.25) - (view.heightOfView * (DeviceSize.isiPadDevice ? -(0) : 0.02))),
            bottomBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
            bottomBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
}
