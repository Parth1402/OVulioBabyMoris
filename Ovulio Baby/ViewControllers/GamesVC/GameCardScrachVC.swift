//
//  GameCardScrachVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-23.
//

import UIKit
import GLScratchCard

class GameCardScrachVC: UIViewController, GLScratchCarImageViewDelegate {
    
    let headlineLabel = CommonView.getCommonLabel(text: "GameCardScrachVC.headlineLabel.text"~, font: .boldSystemFont(ofSize: 24.pulse2Font()), lines: 0, alignment: .center)
    let cardGredientView = UIImageView()
    let scratchCard = GLScratchCardImageView()
    let levelDetailsContainer = CommonView.getViewWithShadowAndRadius(cornerRadius: 22)
    var backDoneButton: UIButton!
    var resetButton: UIButton!
    let resetButtonDidableView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var levelData: GameLevelModel!
    var selectedCardIndex = 0
    
    var doneButtonTapped: (() -> Void)?
    let heightOfDetailView = 135.0
    let heightOfHeadlineLabel = 70.0
    let heightOfButtons = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setUpBackground()
        setUpHeadlineLabel()
        setupScratchCardView()
        setupDetailsAndProbability()
        setupButtons()
    }
    
    func setUpHeadlineLabel() {
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: DeviceSize.isiPadDevice ? ScreenSize.width * 0.2 : 30),
            headlineLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headlineLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -30),
            headlineLabel.heightAnchor.constraint(equalToConstant: heightOfHeadlineLabel)
        ])
    }
    
    func setupButtons() {
        resetButton = CommonView.getCommonButton(title: "GameCardScrachVC.Button.Reset.headline.text"~)
        self.view.addSubview(resetButton)
        // Button Animation
        resetButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        resetButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        resetButton.addTarget(self, action:#selector(resetButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            resetButton.leadingAnchor.constraint(equalTo: cardGredientView.leadingAnchor),
            resetButton.trailingAnchor.constraint(equalTo: cardGredientView.trailingAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.topAnchor.constraint(equalTo: levelDetailsContainer.bottomAnchor, constant: DeviceSize.isiPadDevice ? 28 : 20),
        ])
        
        view.addSubview(resetButtonDidableView)
        resetButtonDidableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetButtonDidableView.topAnchor.constraint(equalTo: resetButton.topAnchor),
            resetButtonDidableView.leadingAnchor.constraint(equalTo: resetButton.leadingAnchor),
            resetButtonDidableView.trailingAnchor.constraint(equalTo: resetButton.trailingAnchor),
            resetButtonDidableView.bottomAnchor.constraint(equalTo: resetButton.bottomAnchor)
        ])
        
        backDoneButton = CommonView.getCommonButton(title: "GameCardScrachVC.Button.Back.headline.text"~, titleColor: appColor, backgroundColor: .white)
        self.view.addSubview(backDoneButton)
        // Button Animation
        backDoneButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        backDoneButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        backDoneButton.addTarget(self, action:#selector(backDoneButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            backDoneButton.leadingAnchor.constraint(equalTo: resetButton.leadingAnchor, constant: 0),
            backDoneButton.trailingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 0),
            backDoneButton.heightAnchor.constraint(equalToConstant: heightOfButtons),
            backDoneButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 10),
        ])
    }
    
    func setupDetailsAndProbability() {
        
        self.view.addSubview(levelDetailsContainer)
        NSLayoutConstraint.activate([
            levelDetailsContainer.leadingAnchor.constraint(equalTo: self.cardGredientView.leadingAnchor),
            levelDetailsContainer.topAnchor.constraint(equalTo: cardGredientView.bottomAnchor, constant: DeviceSize.isiPadDevice ? 33 : 20),
            levelDetailsContainer.widthAnchor.constraint(equalTo: self.cardGredientView.widthAnchor, multiplier: 0.48),
            levelDetailsContainer.heightAnchor.constraint(equalToConstant: heightOfDetailView)
        ])
        let levelHeadlineLabel = CommonView.getCommonLabel(text: levelData.headline, font: .boldSystemFont(ofSize: 16.pulse2Font()))
        levelDetailsContainer.addSubview(levelHeadlineLabel)
        NSLayoutConstraint.activate([
            levelHeadlineLabel.leadingAnchor.constraint(equalTo: levelDetailsContainer.leadingAnchor, constant: DeviceSize.isiPadDevice ? 16 : 20),
            levelHeadlineLabel.topAnchor.constraint(equalTo: levelDetailsContainer.topAnchor, constant: 20),
            levelHeadlineLabel.trailingAnchor.constraint(equalTo: levelDetailsContainer.trailingAnchor, constant: -20),
        ])
        let complexityLabel = CommonView.getCommonLabel(text: levelData.complexity.rawValue, font: .systemFont(ofSize: 14.pulse2Font()))
        levelDetailsContainer.addSubview(complexityLabel)
        NSLayoutConstraint.activate([
            complexityLabel.leadingAnchor.constraint(equalTo: levelHeadlineLabel.leadingAnchor),
            complexityLabel.topAnchor.constraint(equalTo: levelHeadlineLabel.bottomAnchor, constant: DeviceSize.isiPadDevice ? 2 : 5),
            complexityLabel.trailingAnchor.constraint(equalTo: levelHeadlineLabel.trailingAnchor),
        ])
        let starView = StarsView()
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.rating = levelData.complexity.stars
        levelDetailsContainer.addSubview(starView)
        NSLayoutConstraint.activate([
            starView.leadingAnchor.constraint(equalTo: levelHeadlineLabel.leadingAnchor),
            starView.topAnchor.constraint(equalTo: complexityLabel.bottomAnchor, constant: 6),
            starView.trailingAnchor.constraint(equalTo: levelHeadlineLabel.trailingAnchor, constant: -20),
            starView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        var pointsText = "\(levelData.pointPerCard)"
        if levelData.pointPerCard == 1 {
            pointsText = pointsText + " " + NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.Point.text", comment: "")
        } else {
            pointsText = pointsText + " " + NSLocalizedString("GamesVC.LevelsAndPositionCardsHeader.Points.text", comment: "")
        }
        
        let pointsLabel = CommonView.getCommonLabel(text: "+" + pointsText, textColor: lightAppColor, font: .systemFont(ofSize: 14.pulse2Font()))
        levelDetailsContainer.addSubview(pointsLabel)
        NSLayoutConstraint.activate([
            pointsLabel.leadingAnchor.constraint(equalTo: levelHeadlineLabel.leadingAnchor),
            pointsLabel.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 3),
            pointsLabel.trailingAnchor.constraint(equalTo: levelHeadlineLabel.trailingAnchor),
        ])
        
        let probabilityContainer = CommonView.getViewWithShadowAndRadius(cornerRadius: 22)
        self.view.addSubview(probabilityContainer)
        NSLayoutConstraint.activate([
            probabilityContainer.trailingAnchor.constraint(equalTo: self.cardGredientView.trailingAnchor),
            probabilityContainer.bottomAnchor.constraint(equalTo: levelDetailsContainer.bottomAnchor),
            probabilityContainer.widthAnchor.constraint(equalTo: levelDetailsContainer.widthAnchor),
            probabilityContainer.heightAnchor.constraint(equalTo: levelDetailsContainer.heightAnchor)
        ])
        let probabilityHeadlineLabel = CommonView.getCommonLabel(text: "GameCardScrachVC.Probability.headline.text"~, font: .boldSystemFont(ofSize: 16.pulse2Font()))
        probabilityContainer.addSubview(probabilityHeadlineLabel)
        NSLayoutConstraint.activate([
            probabilityHeadlineLabel.leadingAnchor.constraint(equalTo: probabilityContainer.leadingAnchor, constant: 20),
            probabilityHeadlineLabel.topAnchor.constraint(equalTo: probabilityContainer.topAnchor, constant: 20),
            probabilityHeadlineLabel.trailingAnchor.constraint(equalTo: probabilityContainer.trailingAnchor, constant: -20),
        ])
        let genderImageView = UIImageView()
        genderImageView.contentMode = .scaleAspectFit
        genderImageView.image = UIImage(named: levelData.cards[selectedCardIndex].probabilityImage)
        genderImageView.translatesAutoresizingMaskIntoConstraints = false
        probabilityContainer.addSubview(genderImageView)
        NSLayoutConstraint.activate([
            genderImageView.leadingAnchor.constraint(equalTo: probabilityHeadlineLabel.leadingAnchor),
            genderImageView.topAnchor.constraint(equalTo: probabilityHeadlineLabel.bottomAnchor, constant: 17),
            genderImageView.heightAnchor.constraint(equalToConstant: heightOfDetailView - 80),
            genderImageView.widthAnchor.constraint(equalToConstant: heightOfDetailView - 80),
        ])
        let probabilityLabel = CommonView.getCommonLabel(text: levelData.cards[selectedCardIndex].probabilityTitle, textColor: levelData.cards[selectedCardIndex].probability == .boy ? boyAppColor : girlAppColor, font: .boldSystemFont(ofSize: 24.pulse2Font()), alignment: .center)
        probabilityContainer.addSubview(probabilityLabel)
        probabilityLabel.adjustsFontSizeToFitWidth = true
        probabilityLabel.minimumScaleFactor = 0.2
        NSLayoutConstraint.activate([
            probabilityLabel.leadingAnchor.constraint(equalTo: genderImageView.trailingAnchor, constant: 20),
            probabilityLabel.centerYAnchor.constraint(equalTo: genderImageView.centerYAnchor),
            probabilityLabel.trailingAnchor.constraint(equalTo: probabilityContainer.trailingAnchor, constant: -20),
        ])
    }
    
    func setupScratchCardView() {
        cardGredientView.contentMode = .scaleAspectFill
        cardGredientView.image = UIImage(named: levelData.cards[selectedCardIndex].cardImage)
        cardGredientView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardGredientView)
        var heightOfSafeArea = UIScreen.main.bounds.height
        if #available(iOS 11.0, *) {
            let allScenes = UIApplication.shared.connectedScenes
            let scene = allScenes.first { $0.activationState == .foregroundActive }
            if let windowScene = scene as? UIWindowScene {
                heightOfSafeArea = windowScene.keyWindow?.safeAreaLayoutGuide.layoutFrame.height ?? UIScreen.main.bounds.height
            }
        }
        let contentHeightForSum = ((heightOfHeadlineLabel + 20) + (heightOfDetailView + 20) + ((heightOfButtons * 2) + 20 + (30 * 2)))
        let heightOfCardImageView = heightOfSafeArea - contentHeightForSum
        let widthOfCardImageView = (DeviceSize.isiPadDevice ? (ScreenSize.width * 0.68) : ScreenSize.width) - 40
        NSLayoutConstraint.activate([
            cardGredientView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardGredientView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 30),
            cardGredientView.heightAnchor.constraint(equalToConstant: heightOfCardImageView > widthOfCardImageView ? widthOfCardImageView : heightOfCardImageView),
            cardGredientView.widthAnchor.constraint(equalToConstant: heightOfCardImageView > widthOfCardImageView ? widthOfCardImageView : heightOfCardImageView)
        ])
        cardGredientView.layer.cornerRadius = (heightOfCardImageView > widthOfCardImageView ? widthOfCardImageView : heightOfCardImageView) / 2
        cardGredientView.clipsToBounds = true
        scratchCard.layer.cornerRadius = (heightOfCardImageView > widthOfCardImageView ? widthOfCardImageView : heightOfCardImageView) / 2
        handleScratchViewHidden()
    }
    
    func handleScratchViewHidden() {
        self.scratchCard.removeFromSuperview()
        self.view.addSubview(scratchCard)
        scratchCard.translatesAutoresizingMaskIntoConstraints = false
        scratchCard.topAnchor.constraint(equalTo: self.cardGredientView.topAnchor, constant: 0.0).isActive = true
        scratchCard.bottomAnchor.constraint(equalTo: self.cardGredientView.bottomAnchor, constant: 0.0).isActive = true
        scratchCard.leftAnchor.constraint(equalTo: self.cardGredientView.leftAnchor, constant: 0.0).isActive = true
        scratchCard.rightAnchor.constraint(equalTo: self.cardGredientView.rightAnchor, constant: 0.0).isActive = true
        scratchCard.clipsToBounds = true
        scratchCard.image = UIImage(named:"positionCardGredientIMG")!
        scratchCard.lineWidth = 40
        scratchCard.lineType = .round
        scratchCard.benchMarkScratchPercentage = 0
        scratchCard.addDelegate(delegate: self)
        scratchCard.isUserInteractionEnabled = true
        scratchCard.alpha = 1.0
        if levelData.cards[selectedCardIndex].isAlreadyScrached {
            cardGredientView.hero.id = "gredientCardImageHeroID\(selectedCardIndex)"
            scratchCard.isHidden = true
            self.resetButtonDidableView.isHidden = true
        } else {
            scratchCard.hero.id = "gredientCardImageHeroID\(selectedCardIndex)"
            scratchCard.isHidden = false
            cardGredientView.isHidden = true
        }
    }
    
    func bounceView(targetView: UIView) {
        
        let compressionTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        targetView.transform = compressionTransform
        
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.6,
                       options: [],
                       animations: {
            targetView.transform = .identity
        }, completion: nil)
        
    }
    
    func scratchpercentageDidChange(value: Float) {
        
        if self.cardGredientView.isHidden {
            self.cardGredientView.isHidden = false
        }
        
        if value > 40.0 {
            
            if self.resetButtonDidableView.isHidden == false {
                
                // Success
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                self.levelData.cards[self.selectedCardIndex].isAlreadyScrached = true
                self.backDoneButton.setTitle("GameCardScrachVC.Button.Done.headline.text"~, for: .normal)
                self.resetButtonDidableView.isHidden = true
                
                self.bounceView(targetView: self.levelDetailsContainer)
                if self.backDoneButton.titleLabel?.text == "GameCardScrachVC.Button.Done.headline.text"~ {
                    if let action = doneButtonTapped {
                        action()
                    }
                }
                
            }
            
        }
        
    }
    
    func didScratchStarted() {
        
    }
    
    func didScratchEnded() {
        
    }
    
}


// MARK: Actions
extension GameCardScrachVC {
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    @objc func resetButtonTapped(sender: UIButton) {
        sender.showAnimation(isForError: true) {
            self.levelData.cards[self.selectedCardIndex].isAlreadyScrached = false
            self.handleScratchViewHidden()
            self.resetButtonDidableView.isHidden = false
            self.backDoneButton.setTitle("GameCardScrachVC.Button.Done.headline.text"~, for: .normal)
            if self.backDoneButton.titleLabel?.text == "GameCardScrachVC.Button.Done.headline.text"~ {
                if let action = self.doneButtonTapped {
                    action()
                }
            }
            //        if self.scratchCard.isHidden == true {
            //            // Show Scratch Card
            //            self.scratchCard.alpha = 0.0
            //            self.scratchCard.isHidden = false
            //
            //            UIView.animate(withDuration: 0.3) {
            //                self.scratchCard.alpha = 1.0
            //            }
            //        }
        }
    }
    
    @objc func backDoneButtonTapped(sender: UIButton) {
        
        sender.showAnimation {
            if self.backDoneButton.titleLabel?.text == "GameCardScrachVC.Button.Done.headline.text"~ {
                if (GamesDataManager.shared.needToShowLegsUpScreen == nil || GamesDataManager.shared.needToShowLegsUpScreen == true) && self.levelData.cards[self.selectedCardIndex].isAlreadyScrached {
                    GamesDataManager.shared.updateNeedToShowLegsUpScreen(true)
                }
                if let action = self.doneButtonTapped {
                    action()
                }
            }
            self.dismiss(animated: true)
        }
        
    }
    
}
