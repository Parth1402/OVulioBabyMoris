//
//  DemoDataAlertVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-12-01.
//

import UIKit

class DemoDataAlertVC: UIViewController {
    
    let blackBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let popUpContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "FFF2F2")
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = appColor
        label.text = "DemoDataAlertVC.headlineLabel.text"~
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var UnlockForMoreFunButton: UIButton = {
        let button = UIButton()
        button.setTitle("SalesVC.button.UnlockForMoreFun.text"~, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = buttonAppLightColor
        button.layer.cornerRadius = 15
        return button
    }()
    var didPurchaseSuccessfully: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(blackBackground)
        NSLayoutConstraint.activate([
            blackBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blackBackground.topAnchor.constraint(equalTo: self.view.topAnchor),
            blackBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            blackBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCustomPopup))
        blackBackground.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(popUpContainerView)
        
//        blackBackground.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        blackBackground.alpha = 0.0
        popUpContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        popUpContainerView.alpha = 0.0
        
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.popUpContainerView.transform = .identity
                self.popUpContainerView.alpha = 1.0
                self.blackBackground.transform = .identity
                self.blackBackground.alpha = 1.0
            }, completion: nil)
        }
        
        NSLayoutConstraint.activate([
            popUpContainerView.centerXAnchor.constraint(equalTo: blackBackground.centerXAnchor),
            popUpContainerView.centerYAnchor.constraint(equalTo: blackBackground.centerYAnchor, constant: 0),
            popUpContainerView.widthAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.5) : (self.view.bounds.width - 30)),
        ])
        
        popUpContainerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popUpContainerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: popUpContainerView.centerXAnchor, constant: 20)
        ])
        
        let imageView = CommonView.getCommonImageView(image: "demoDataAlertImage")
        self.popUpContainerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "closeButtonNotEnoughData"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissCustomPopupOnCloseTap), for: .touchUpInside)
        self.popUpContainerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: self.popUpContainerView.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        let subtitleLable = CommonView.getCommonLabel(text: "DemoDataAlertVC.subtitle.text"~, lines: 0, alignment: .center)
        self.popUpContainerView.addSubview(subtitleLable)
        NSLayoutConstraint.activate([
            subtitleLable.leadingAnchor.constraint(equalTo: popUpContainerView.leadingAnchor, constant: 30),
            subtitleLable.trailingAnchor.constraint(equalTo: popUpContainerView.trailingAnchor, constant: -30),
            subtitleLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
        ])
        
        popUpContainerView.addSubview(UnlockForMoreFunButton)
        UnlockForMoreFunButton.translatesAutoresizingMaskIntoConstraints = false
        // Button Animation
        UnlockForMoreFunButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        UnlockForMoreFunButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        UnlockForMoreFunButton.addTarget(self, action: #selector(UnlockForMoreFunButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            UnlockForMoreFunButton.leadingAnchor.constraint(equalTo: popUpContainerView.leadingAnchor, constant: 20),
            UnlockForMoreFunButton.topAnchor.constraint(equalTo: subtitleLable.bottomAnchor, constant: 20),
            UnlockForMoreFunButton.trailingAnchor.constraint(equalTo: popUpContainerView.trailingAnchor, constant: -20),
            UnlockForMoreFunButton.heightAnchor.constraint(equalToConstant: 50),
            UnlockForMoreFunButton.bottomAnchor.constraint(equalTo: popUpContainerView.bottomAnchor, constant: -20),
        ])
        
    }
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    @objc func UnlockForMoreFunButtonTapped(_ sender: UIButton) {
        sender.showAnimation() {
            let vc = SalesVC()
            vc.didPurchaseSuccessfully = {
                if let action = self.didPurchaseSuccessfully {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                    action()
                }
            }
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func dismissCustomPopupOnCloseTap(_ sender: UIButton) {
        
        // Error
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        self.dismiss(animated: true)
        
    }
    
    @objc func dismissCustomPopup() {
        self.dismiss(animated: true)
    }
    
}
