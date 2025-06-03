//
//  SwipeNameCardVC.swift
//  Ovulio Baby
//
//  Created by USER on 14/04/25.
//

import UIKit

class SwipeNameCardVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    
    var cardStack: [SwipeCardView] = []
    
    // var names: [(first: String, last: String)] = []
    
    var names: [(first: String, last: String)] = [
        ("Jessica", "Blankenship"),
        ("Oliver", "Smith"),
        ("Emma", "Johnson"),
        ("Liam", "Williams")
    ]
    
var selectedNames: [String] = []
    
    var NameGenerateContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    
    let TitleText: UILabel = {
        let label = UILabel()
        label.text = "SwipeNameCardVC.header.text"~
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = appColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameToggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(hexString: "FF76B7")
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    let toggleLabel: UILabel = {
        let label = UILabel()
        label.text = "SwipeNameCardVC.lastName.text"~
        label.font = UIFont.mymediumSystemFont(ofSize: 16)
        label.textColor = appColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dislikeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonBrokenHeart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Buttonheart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setUpBackground()
        
        self.view.addSubview(NameGenerateContentContainer)
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                NameGenerateContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                NameGenerateContentContainer.widthAnchor.constraint(equalToConstant: 460),
                NameGenerateContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                NameGenerateContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }else{
            NSLayoutConstraint.activate([
                NameGenerateContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                NameGenerateContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                NameGenerateContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                NameGenerateContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        setUpNavigationBar()
        setUpView()
        
        let language = MultiLanguage.MultiLanguageConst.currentAppleLanguage()
        print(language)
        
    }
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"))
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                self.dismiss(animated: true)
            }
            self.view.addSubview(customNavBarView)
            customNavBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customNavBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
            
        }
        
        NameGenerateContentContainer.addSubview(TitleText)
    }
    
    func setUpView() {
        nameToggleSwitch.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
        likeButton.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDislikeButtonTapped), for: .touchUpInside)
        
        
        for (_, name) in names.reversed().enumerated() {
            let card = SwipeCardView(firstName: name.0, lastName: name.1)
            cardContainer.addSubview(card)
            card.applySwipeGesture(target: self, action: #selector(handleSwipe(_:)))
            card.updateName(firstName: name.0, lastName: name.1, showLastName: nameToggleSwitch.isOn)
            
            NSLayoutConstraint.activate([
                card.topAnchor.constraint(equalTo: cardContainer.topAnchor),
                card.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor),
                card.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor),
                card.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor)
            ])
            cardStack.append(card)
        }
        
        // Add searchBar before setting constraints
        NameGenerateContentContainer.addSubview(TitleText)
        
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        NameGenerateContentContainer.addSubview(cardContainer)
        
        NameGenerateContentContainer.addSubview(toggleLabel)
        NameGenerateContentContainer.addSubview(nameToggleSwitch)
        
        NameGenerateContentContainer.addSubview(dislikeButton)
        NameGenerateContentContainer.addSubview(likeButton)
        
        
        if let customNavBarView = customNavBarView {
            TitleText.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        } else {
            TitleText.topAnchor.constraint(equalTo: NameGenerateContentContainer.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        
        NSLayoutConstraint.activate([
            // Search bar constraints
            TitleText.topAnchor.constraint(equalTo: NameGenerateContentContainer.safeAreaLayoutGuide.topAnchor, constant: 10),
            TitleText.leadingAnchor.constraint(equalTo: NameGenerateContentContainer.leadingAnchor, constant: 16),
            TitleText.trailingAnchor.constraint(equalTo: NameGenerateContentContainer.trailingAnchor, constant: -16),
            // TitleText.heightAnchor.constraint(equalToConstant: 30) // Set fixed height
            
            cardContainer.centerXAnchor.constraint(equalTo: NameGenerateContentContainer.centerXAnchor),
            cardContainer.topAnchor.constraint(equalTo: TitleText.bottomAnchor, constant: 35),
            cardContainer.widthAnchor.constraint(equalTo: NameGenerateContentContainer.widthAnchor, constant: -60),
            cardContainer.heightAnchor.constraint(equalTo: NameGenerateContentContainer.widthAnchor, constant: -20),

            
            toggleLabel.topAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: 35),
            toggleLabel.centerXAnchor.constraint(equalTo: NameGenerateContentContainer.centerXAnchor, constant: -30),
            
            nameToggleSwitch.centerYAnchor.constraint(equalTo: toggleLabel.centerYAnchor),
            nameToggleSwitch.leadingAnchor.constraint(equalTo: toggleLabel.trailingAnchor, constant: 10),
            
            
            dislikeButton.bottomAnchor.constraint(equalTo: NameGenerateContentContainer.bottomAnchor, constant: -70),
            dislikeButton.leadingAnchor.constraint(equalTo: NameGenerateContentContainer.leadingAnchor, constant: 50),
            dislikeButton.widthAnchor.constraint(equalToConstant: 65),
            dislikeButton.heightAnchor.constraint(equalToConstant: 65),
            
            likeButton.bottomAnchor.constraint(equalTo: NameGenerateContentContainer.bottomAnchor, constant: -70),
            likeButton.trailingAnchor.constraint(equalTo: NameGenerateContentContainer.trailingAnchor, constant: -50),
            likeButton.widthAnchor.constraint(equalToConstant: 65),
            likeButton.heightAnchor.constraint(equalToConstant: 65)
        ])
        
    }
    
    private func reloadCards() {
        
        for (_, name) in names.reversed().enumerated() {
            let card = SwipeCardView(firstName: name.0, lastName: name.1)
            cardContainer.addSubview(card)
            card.applySwipeGesture(target: self, action: #selector(handleSwipe(_:)))
            card.updateName(firstName: name.0, lastName: name.1, showLastName: nameToggleSwitch.isOn)
            
            NSLayoutConstraint.activate([
                card.topAnchor.constraint(equalTo: cardContainer.topAnchor),
                card.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor),
                card.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor),
                card.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor)
            ])
            cardStack.append(card)
        }
    }
}


// MARK: UIAction
extension SwipeNameCardVC {
    
    @objc func toggleSwitched() {
        for (index, card) in cardStack.enumerated() {
            let name = names.reversed()[index]
            card.updateName(firstName: name.0, lastName: name.1, showLastName: nameToggleSwitch.isOn)
        }
        
    }
    
    
    @objc func handleLikeButtonTapped() {
        likeButton.isUserInteractionEnabled = false
        self.removeTopCard(toRight: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.likeButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func handleDislikeButtonTapped() {
        dislikeButton.isUserInteractionEnabled = false
        self.removeTopCard(toRight: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.dislikeButton.isUserInteractionEnabled = true
        }
    }
    
    private func removeTopCard(toRight: Bool) {
        guard let topCard = cardStack.last else { return }
        
        let direction: CGFloat = toRight ? 1 : -1
        let rotationAngle: CGFloat = direction * .pi / 6 // Rotate about 18 degrees
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            // Apply rotation + translation
            topCard.transform = CGAffineTransform(rotationAngle: rotationAngle)
                .concatenating(CGAffineTransform(translationX: direction * 500, y: 100))
            topCard.alpha = 0
        }, completion: { _ in
            if toRight {
                
                let SelectionTYpe : FavouriteCategory = NameGenerateDataBeforeSaving.selectedGender.rawValue == 1 ? .boys : NameGenerateDataBeforeSaving.selectedGender.rawValue == 2 ? .girls : .unisex
                
                if SelectionTYpe == .boys {
                    self.selectedNames = NameGenerateManager.shared.getFavouriteNames(for: .boys)
                    self.selectedNames.append(topCard.nameLabel.text ?? "")
                }else if SelectionTYpe == .girls {
                    self.selectedNames = NameGenerateManager.shared.getFavouriteNames(for: .girls)
                    self.selectedNames.append(topCard.nameLabel.text ?? "")
                    
                }else {
                    
                    self.selectedNames = NameGenerateManager.shared.getFavouriteNames(for: .unisex)
                    
                    self.selectedNames.append(topCard.nameLabel.text ?? "")
                    
                }
                
               // self.selectedNames.append(topCard.nameLabel.text ?? "")
                NameGenerateManager.shared.saveFavouriteNames(self.selectedNames, for: SelectionTYpe)
            }
            topCard.removeFromSuperview()
            //self.cardStack.removeLast()
            self.cardStack.removeAll { $0 == topCard }
            
            if self.cardStack.isEmpty {
                let destinationViewController = FavouriteNameVC()
                destinationViewController.isNameGenerate = false
                destinationViewController.modalPresentationStyle = .fullScreen

                self.present(destinationViewController, animated: false, completion: nil)
            }
        })
    }
    
    @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view as? SwipeCardView else { return }

        let translation = gesture.translation(in: view)
        let cardWidth = card.bounds.width
        let percent = min(abs(translation.x) / cardWidth, 1)
        let direction: CGFloat = translation.x > 0 ? 1 : -1

        let rotationAngle = direction * percent * (.pi / 6)
        let rotation = CGAffineTransform(rotationAngle: rotationAngle)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        card.transform = rotation.concatenating(translationTransform)

        if gesture.state == .changed {
            card.transform = translationTransform.concatenating(rotation)

            // Show heart or broken heart
            card.heartImageView.alpha = translation.x > 0 ? 1.0 : 0
            card.brokenHeartImageView.alpha = translation.x < 0 ? 1.0 : 0
        } else if gesture.state == .ended {
            if abs(translation.x) > 120 {
                // Save on RIGHT swipe
                if direction > 0 {
                    let SelectionTYpe : FavouriteCategory = NameGenerateDataBeforeSaving.selectedGender.rawValue == 1 ? .boys : NameGenerateDataBeforeSaving.selectedGender.rawValue == 2 ? .girls : .unisex
                    
                    if SelectionTYpe == .boys {
                        self.selectedNames = NameGenerateManager.shared.getFavouriteNames(for: .boys)
                        self.selectedNames.append(card.nameLabel.text ?? "")
                    }else if SelectionTYpe == .girls {
                        self.selectedNames = NameGenerateManager.shared.getFavouriteNames(for: .girls)
                        self.selectedNames.append(card.nameLabel.text ?? "")
                        
                    }else {
                        
                        self.selectedNames = NameGenerateManager.shared.getFavouriteNames(for: .unisex)
                        
                        self.selectedNames.append(card.nameLabel.text ?? "")
                        
                    }
                    
                   // self.selectedNames.append(topCard.nameLabel.text ?? "")
                    NameGenerateManager.shared.saveFavouriteNames(self.selectedNames, for: SelectionTYpe)
                }

                let offScreenTransform = CGAffineTransform(
                    translationX: view.bounds.width * 1.5 * direction,
                    y: -view.bounds.height * 0.5
                ).rotated(by: direction * (.pi / 4))

                UIView.animate(withDuration: 0.4, animations: {
                    card.alpha = 0
                    card.transform = offScreenTransform
                }, completion: { _ in
                    card.removeFromSuperview()
                    self.cardStack.removeAll { $0 == card }

                    if self.cardStack.isEmpty {
                        let destinationViewController = FavouriteNameVC()
                        destinationViewController.modalPresentationStyle = .fullScreen
                        destinationViewController.isNameGenerate = false
                        self.present(destinationViewController, animated: false, completion: nil)
                    }
                })
            } else {
                // Reset
                UIView.animate(withDuration: 0.3) {
                    card.transform = .identity
                    card.heartImageView.alpha = 0
                    card.brokenHeartImageView.alpha = 0
                }
            }
        }
    }

    
    
    //    @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
    //        guard let card = gesture.view as? SwipeCardView else { return }
    //
    //        let translation = gesture.translation(in: view)
    //        let cardWidth = card.bounds.width
    //        let percent = min(abs(translation.x) / cardWidth, 1)
    //        let direction: CGFloat = translation.x > 0 ? 1 : -1
    //
    //        // Rotate and move
    //        let rotationAngle = direction * percent * (.pi / 6)
    //        let rotation = CGAffineTransform(rotationAngle: rotationAngle)
    //        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
    //
    //        switch gesture.state {
    //        case .changed:
    //            card.transform = translationTransform.concatenating(rotation)
    //
    //            // Handle heart icon visibility
    //            if translation.x > 0 {
    //                card.heartImageView.alpha = 1.0//percent
    //                card.brokenHeartImageView.alpha = 0
    //            } else if translation.x < 0 {
    //                card.brokenHeartImageView.alpha = 1.0//percent
    //                card.heartImageView.alpha = 0
    //            } else {
    //                card.heartImageView.alpha = 0
    //                card.brokenHeartImageView.alpha = 0
    //            }
    //
    //        case .ended:
    //            if abs(translation.x) > 120 {
    //                UIView.animate(withDuration: 0.3, animations: {
    //                    card.center.x += direction * 500
    //                    card.alpha = 0
    //                }, completion: { _ in
    //                    card.removeFromSuperview()
    //                    self.cardStack.removeAll { $0 == card }
    //
    //                    if self.cardStack.isEmpty {
    //                                   self.reloadCards() // 👈 Call your method to reload
    //                               }
    //                })
    //            } else {
    //                // Reset if not enough swipe
    //                UIView.animate(withDuration: 0.3) {
    //                    card.transform = .identity
    //                    card.heartImageView.alpha = 0
    //                    card.brokenHeartImageView.alpha = 0
    //                }
    //            }
    //
    //        default:
    //            break
    //        }
    //    }
}
