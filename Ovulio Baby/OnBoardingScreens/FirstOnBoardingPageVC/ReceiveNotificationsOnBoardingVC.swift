//
//  ReceiveNotificationsOnBoardingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-25.
//

import UIKit

class ReceiveNotificationsOnBoardingVC: UIViewController {

    let allowButton = CommonView.getCommonButton(title: "FirstOnBoardingPageVC.Button.Allow.headlineLabel.text"~, font: .mymediumSystemFont(ofSize: 16), cornerRadius: 20)
    let skipButton = CommonView.getCommonButton(title: "FirstOnBoardingPageVC.Button.Skip.headlineLabel.text"~, font: .systemFont(ofSize: 16), titleColor: appColor, backgroundColor: .clear)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.setUpBackground()
        let bottomBackgroundImageView = CommonView.getCommonImageView(image: "splashScreenInBackground")
        bottomBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBackgroundImageView)
        NSLayoutConstraint.activate([
            bottomBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
        
        allowButton.addTarget(self, action: #selector(allowButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(allowButton)
        NSLayoutConstraint.activate([
            allowButton.leadingAnchor.constraint(equalTo: bottomBackgroundImageView.leadingAnchor, constant: DeviceSize.onbordingButtonLeftRightPadding),
            allowButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -((ScreenSize.height * 0.25) / 8)),
            allowButton.trailingAnchor.constraint(equalTo: bottomBackgroundImageView.trailingAnchor, constant: -DeviceSize.onbordingButtonLeftRightPadding),
            allowButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        skipButton.addTarget(self, action: #selector(skipTheStep(_:)), for: .touchUpInside)
        self.view.addSubview(skipButton)
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: bottomBackgroundImageView.leadingAnchor, constant: DeviceSize.onbordingButtonLeftRightPadding),
            skipButton.bottomAnchor.constraint(equalTo: allowButton.topAnchor, constant: -8),
            skipButton.trailingAnchor.constraint(equalTo: bottomBackgroundImageView.trailingAnchor, constant: -DeviceSize.onbordingButtonLeftRightPadding),
            skipButton.topAnchor.constraint(greaterThanOrEqualTo: bottomBackgroundImageView.topAnchor, constant: 10)
        ])
        
        let bottomImageView = CommonView.getCommonImageView(image: "ReceiveNotificationsOnBoardingVCIMG")
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.contentMode = .scaleAspectFit
        self.view.addSubview(bottomImageView)
        NSLayoutConstraint.activate([
            bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            bottomImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15),
            bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
            bottomImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: ScreenSize.height * (DeviceSize.isiPadDevice ? 0.0003 : 0.0005))
        ])
        
        let headlineLabel = CommonView.getCommonLabel(text: "ReceiveNotificationsOnBoardingVC.headlineLabel.text"~, font: .boldSystemFont(ofSize: DeviceSize.fontFor26), lines: 0, alignment: .center)
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingContentLeftRightPadding),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DeviceSize.onbordingContentTopPadding),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingContentLeftRightPadding),
        ])
        
        let headlineDescriptionLabel = CommonView.getCommonLabel(text: "ReceiveNotificationsOnBoardingVC.headlineDescriptionLabel.text"~, font: .systemFont(ofSize: DeviceSize.fontFor14), lines: 0, alignment: .center)
        self.view.addSubview(headlineDescriptionLabel)
        NSLayoutConstraint.activate([
            headlineDescriptionLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor, constant: 10),
            headlineDescriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 15),
            headlineDescriptionLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor, constant: -10),
        ])
    }
}

// MARK: Actions
extension ReceiveNotificationsOnBoardingVC {
    
    @objc func allowButtonTapped(_ sender: UIButton) {
        allowButton.showAnimation {
            UNUserNotificationCenter
                .current()
                .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                    if granted == true && error == nil {
                        DispatchQueue.main.async {
                            let vc = SecondOnBoardingPageVC()
                            vc.modalPresentationStyle = .currentContext
                            self.present(vc, animated: true)
                        }
                    }
                }
        }
    }
    
    @objc func skipTheStep(_ sender: UIButton) {
        skipButton.showAnimation(isForError: true) {
            let vc = SecondOnBoardingPageVC()
            vc.modalPresentationStyle = .currentContext
            self.present(vc, animated: true)
        }
    }
}
