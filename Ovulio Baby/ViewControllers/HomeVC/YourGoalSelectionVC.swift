//
//  YourGoalSelectionVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-09.
//

import UIKit

class YourGoalSelectionVC: UIViewController {
    
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
        label.text = "YourGoalSelectionVC.headlineLabel.text"~
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonContainerView: UIView = {
        let buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        return buttonContainerView
    }()
    
    var genderUpdationProtocolDelegate: GenderUpdationProtocol?
    
    
    let boyBorderView = UIView()
    let boyContainerView = UIView()
    
    let girlContainerView = UIView()
    let girlBorderView = UIView()
    
    let doesntMatterContainerView = UIView()
    let doesntMatterBorderView = UIView()
    
    let buttonViewHeight = DeviceSize.isiPadDevice ? 130.0 : 120.0
    let screenWidthForButton = DeviceSize.isiPadDevice ? 80.0 : 66.0
    
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
            popUpContainerView.centerYAnchor.constraint(equalTo: blackBackground.centerYAnchor, constant: -(self.view.bounds.height * 0.15)),
        ])
        
        if DeviceSize.isiPadDevice {
            popUpContainerView.widthAnchor.constraint(equalToConstant: 380).isActive = true
        }else{
            popUpContainerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 30).isActive = true
        }
        
        popUpContainerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popUpContainerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: popUpContainerView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: popUpContainerView.trailingAnchor, constant: -18),
        ])
        
        popUpContainerView.addSubview(buttonContainerView)
        NSLayoutConstraint.activate([
            buttonContainerView.leadingAnchor.constraint(equalTo: popUpContainerView.leadingAnchor, constant: 18),
            buttonContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            buttonContainerView.trailingAnchor.constraint(equalTo: popUpContainerView.trailingAnchor, constant: -18),
            buttonContainerView.bottomAnchor.constraint(equalTo: popUpContainerView.bottomAnchor, constant: -21),
        ])
        
        makeBoyGoalView()
        makeGirlGoalView()
        makeDoesntMatterGoalView()
    }
    
    @objc func handleGoalSelection(_ sender: UITapGestureRecognizer) {
        if let buttonTag = sender.view?.tag {
            self.boyBorderView.layer.borderWidth = 0
            self.girlBorderView.layer.borderWidth = 0
            self.doesntMatterBorderView.layer.borderWidth = 0
            switch buttonTag {
            case 1:
                boyContainerView.showAnimation({
                    self.boyBorderView.layer.borderWidth = 2
                    ProfileDataManager.shared.updateGender(to: .boy)
                    if let delegate = self.genderUpdationProtocolDelegate {
                        delegate.isGenderChanged()
                    }
                    self.dismissCustomPopup(delay: 0.3)
                })
                break
            case 2:
                girlContainerView.showAnimation({
                    self.girlBorderView.layer.borderWidth = 2
                    ProfileDataManager.shared.updateGender(to: .girl)
                    if let delegate = self.genderUpdationProtocolDelegate {
                        delegate.isGenderChanged()
                    }
                    self.dismissCustomPopup(delay: 0.3)
                })
                break
            case 3:
                doesntMatterContainerView.showAnimation({
                    self.doesntMatterBorderView.layer.borderWidth = 2
                    ProfileDataManager.shared.updateGender(to: .doesntMatter)
                    if let delegate = self.genderUpdationProtocolDelegate {
                        delegate.isGenderChanged()
                    }
                    self.dismissCustomPopup(delay: 0.3)
                })
                break
            default:
                break
            }
        }
    }
    
    @objc func dismissCustomPopup(delay: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: ((.now()) + delay)) {
            UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
                self.popUpContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.popUpContainerView.alpha = 0.0
                self.dismiss(animated: true)
            }) { _ in
                
            }
        }
    }
}

// MARK: Goal Button Views
extension YourGoalSelectionVC {
    
    func makeBoyGoalView() {        
        buttonContainerView.addSubview(boyContainerView)
        boyContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyContainerView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            boyContainerView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 15),
            boyContainerView.widthAnchor.constraint(equalToConstant: (DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.33),
            boyContainerView.heightAnchor.constraint(equalToConstant: buttonViewHeight),
            boyContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
        boyContainerView.tag = 1
        boyContainerView.addGestureRecognizer(tapGesture)
        
        boyBorderView.backgroundColor = .white
        boyContainerView.addSubview(boyBorderView)
        boyBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyBorderView.centerXAnchor.constraint(equalTo: boyContainerView.centerXAnchor),
            boyBorderView.bottomAnchor.constraint(equalTo: boyContainerView.bottomAnchor),
            boyBorderView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.33) - (DeviceSize.isiPadDevice ? 25 : 12)),
            boyBorderView.heightAnchor.constraint(equalToConstant: (buttonViewHeight - 40))
        ])
        boyBorderView.layer.cornerRadius = 20
        boyBorderView.clipsToBounds = true
        boyBorderView.layer.borderWidth = ProfileDataManager.shared.selectedGender == .boy ? 2 : 0
        boyBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
        boyBorderView.dropShadow()
        
        
        let boyLabel = UILabel()
        boyLabel.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        boyLabel.text = "YourGoalSelectionVC.gender.boy.text"~
        boyLabel.textAlignment = .center
        boyLabel.textColor = appColor
        boyBorderView.addSubview(boyLabel)
        boyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyLabel.leadingAnchor.constraint(equalTo: boyBorderView.leadingAnchor),
            boyLabel.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: 20),
            boyLabel.trailingAnchor.constraint(equalTo: boyBorderView.trailingAnchor),
            boyLabel.bottomAnchor.constraint(equalTo: boyBorderView.bottomAnchor),
        ])
        
        let buttonImageView = UIImageView(image: UIImage(named: "boyButtonIMG"))
        boyContainerView.addSubview(buttonImageView)
        buttonImageView.contentMode = .scaleAspectFit
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonImageView.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: -((DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.22) / 2),
            buttonImageView.centerXAnchor.constraint(equalTo: boyContainerView.centerXAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: (DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.22),
            buttonImageView.heightAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) - 20) * 0.22),
        ])
    }
    
    func makeGirlGoalView() {
        
        girlContainerView.backgroundColor = .clear
        buttonContainerView.addSubview(girlContainerView)
        girlContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            girlContainerView.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor),
            girlContainerView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 15),
            girlContainerView.widthAnchor.constraint(equalToConstant: (DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.33),
            girlContainerView.heightAnchor.constraint(equalToConstant: buttonViewHeight),
            girlContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
        girlContainerView.tag = 2
        girlContainerView.addGestureRecognizer(tapGesture)
        
        girlBorderView.backgroundColor = .white
        girlBorderView.layer.removeAllAnimations()
        girlBorderView.layer.removeFromSuperlayer()
        girlContainerView.addSubview(girlBorderView)
        girlBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            girlBorderView.centerXAnchor.constraint(equalTo: girlContainerView.centerXAnchor),
            girlBorderView.bottomAnchor.constraint(equalTo: girlContainerView.bottomAnchor),
            girlBorderView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.33) - (DeviceSize.isiPadDevice ? 25 : 12)),
            girlBorderView.heightAnchor.constraint(equalToConstant: (buttonViewHeight - 40))
        ])
        
        girlBorderView.layer.cornerRadius = 20
        girlBorderView.clipsToBounds = true
        girlBorderView.layer.borderWidth = ProfileDataManager.shared.selectedGender == .girl ? 2 : 0
        girlBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
        girlBorderView.dropShadow()
        
        
        let boyLabel = UILabel()
        boyLabel.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        boyLabel.text = "YourGoalSelectionVC.gender.girl.text"~
        boyLabel.textAlignment = .center
        boyLabel.textColor = appColor
        girlBorderView.addSubview(boyLabel)
        boyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyLabel.leadingAnchor.constraint(equalTo: girlBorderView.leadingAnchor),
            boyLabel.topAnchor.constraint(equalTo: girlBorderView.topAnchor, constant: 20),
            boyLabel.trailingAnchor.constraint(equalTo: girlBorderView.trailingAnchor),
            boyLabel.bottomAnchor.constraint(equalTo: girlBorderView.bottomAnchor),
        ])
        
        let buttonImageView = UIImageView(image: UIImage(named: "girlButtonIMG"))
        girlContainerView.addSubview(buttonImageView)
        buttonImageView.contentMode = .scaleAspectFit
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonImageView.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: -((DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.22) / 2),
            buttonImageView.centerXAnchor.constraint(equalTo: girlContainerView.centerXAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: (DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.22),
            buttonImageView.heightAnchor.constraint(equalToConstant: (DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.22),
        ])
    }
    
    func makeDoesntMatterGoalView() {
        
        doesntMatterContainerView.backgroundColor = .clear
        buttonContainerView.addSubview(doesntMatterContainerView)
        doesntMatterContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doesntMatterContainerView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            doesntMatterContainerView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 15),
            doesntMatterContainerView.widthAnchor.constraint(equalToConstant: (DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.33),
            doesntMatterContainerView.heightAnchor.constraint(equalToConstant: buttonViewHeight),
            doesntMatterContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoalSelection))
        doesntMatterContainerView.tag = 3
        doesntMatterContainerView.addGestureRecognizer(tapGesture)
        
        doesntMatterBorderView.backgroundColor = .white
        doesntMatterContainerView.addSubview(doesntMatterBorderView)
        doesntMatterBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doesntMatterBorderView.centerXAnchor.constraint(equalTo: doesntMatterContainerView.centerXAnchor),
            doesntMatterBorderView.bottomAnchor.constraint(equalTo: doesntMatterContainerView.bottomAnchor),
            doesntMatterBorderView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.33) - (DeviceSize.isiPadDevice ? 25 : 12)),
            doesntMatterBorderView.heightAnchor.constraint(equalToConstant: (buttonViewHeight - 40))
        ])
        doesntMatterBorderView.layer.cornerRadius = 20
        doesntMatterBorderView.clipsToBounds = true
        doesntMatterBorderView.layer.borderWidth = ProfileDataManager.shared.selectedGender == .doesntMatter ? 2 : 0
        doesntMatterBorderView.layer.borderColor = UIColor(hexString: "AA97BD")?.cgColor
        doesntMatterBorderView.dropShadow()
        
        
        let boyLabel = UILabel()
        boyLabel.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        boyLabel.text = "YourGoalSelectionVC.gender.doesntMatter.text"~
        boyLabel.numberOfLines = 0
        boyLabel.textAlignment = .center
        boyLabel.textColor = appColor
        doesntMatterBorderView.addSubview(boyLabel)
        boyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boyLabel.leadingAnchor.constraint(equalTo: doesntMatterBorderView.leadingAnchor, constant: 10),
            boyLabel.topAnchor.constraint(equalTo: doesntMatterBorderView.topAnchor, constant: 25),
            boyLabel.trailingAnchor.constraint(equalTo: doesntMatterBorderView.trailingAnchor, constant: -10),
            boyLabel.bottomAnchor.constraint(equalTo: doesntMatterBorderView.bottomAnchor),
        ])
        
        let buttonImageView = UIImageView(image: UIImage(named: "doesntMatterButtonIMG"))
        doesntMatterContainerView.addSubview(buttonImageView)
        buttonImageView.contentMode = .scaleAspectFit
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonImageView.topAnchor.constraint(equalTo: boyBorderView.topAnchor, constant: -((DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) * 0.22) / 2),
            buttonImageView.centerXAnchor.constraint(equalTo: doesntMatterContainerView.centerXAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) - 20) * 0.22),
            buttonImageView.heightAnchor.constraint(equalToConstant: ((DeviceSize.isiPadDevice ? 380 : (self.view.bounds.width - screenWidthForButton)) - 20) * 0.22),
        ])
    }
}
