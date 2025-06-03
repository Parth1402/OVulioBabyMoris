//
//  YogaDetailVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-03-19.
//

import UIKit
import GLScratchCard

class YogaDetailVC: UIViewController, GLScratchCarImageViewDelegate {
    
    var customNavBarView: CustomNavigationBar?
    let headlineLabel = CommonView.getCommonLabel(text: "YogaDetailVC.headlineLabel.text"~, font: .boldSystemFont(ofSize: 24.pulse2Font()), lines: 0, alignment: .center)
    let cardGredientView = UIImageView()
    let scratchCard = GLScratchCardImageView()
    var resetButton: UIButton!
    let resetButtonDidableView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var selectedCardIndex = 0
    var tableView = UITableView(frame: CGRect.zero, style: .plain)
    var yogaFertilityPositionElement: YogaFertilityPositionModel!
    var saveAfterScratcingCard: (() -> Void)?
    private var currentImageIndex = 0
    private var imageChangeTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setUpBackground()
        setUpNavigationBar()
        setupScratchCardView()
        setupTableView()
        if yogaFertilityPositionElement.isScratched {
            startImageLoop()
        }
    }
    
    private func startImageLoop() {
        imageChangeTimer?.invalidate()
        imageChangeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateImage), userInfo: nil, repeats: true)
    }
    
    @objc private func updateImage() {
        currentImageIndex += 1
        if currentImageIndex >= yogaFertilityPositionElement.images.count {
            currentImageIndex = 0
        }
        cardGredientView.image = UIImage(named: yogaFertilityPositionElement.images[currentImageIndex])
    }
    
    deinit {
        imageChangeTimer?.invalidate()
    }
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg")
        )
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                if let action = self.saveAfterScratcingCard {
                    action()
                }
                self.dismiss(animated: true)
            }
            self.view.addSubview(customNavBarView)
            customNavBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customNavBarView.heightAnchor.constraint(equalToConstant: 70),
            ])
        }
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            headlineLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            //            headlineLabel.widthAnchor.constraint(equalToConstant: self.view.widthOfView * 0.8)
        ])
    }
    
    func setupScratchCardView() {
        cardGredientView.contentMode = .scaleAspectFill
        cardGredientView.image = UIImage(named: yogaFertilityPositionElement.images[0])
        cardGredientView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardGredientView)
        //        var heightOfSafeArea = UIScreen.main.bounds.height
        //        if #available(iOS 11.0, *) {
        //            let allScenes = UIApplication.shared.connectedScenes
        //            let scene = allScenes.first { $0.activationState == .foregroundActive }
        //            if let windowScene = scene as? UIWindowScene {
        //                heightOfSafeArea = windowScene.keyWindow?.safeAreaLayoutGuide.layoutFrame.height ?? UIScreen.main.bounds.height
        //            }
        //        }
        //        let contentHeightForSum = ((heightOfHeadlineLabel + 20) + (heightOfDetailView + 20) + ((heightOfButtons * 2) + 20 + (30 * 2)))
        //        let heightOfCardImageView = heightOfSafeArea - contentHeightForSum
        let widthOfCardImageView = (DeviceSize.isiPadDevice ? (ScreenSize.width * 0.68) : ScreenSize.width) - 60
        NSLayoutConstraint.activate([
            cardGredientView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardGredientView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 30),
            cardGredientView.heightAnchor.constraint(equalToConstant: widthOfCardImageView),
            cardGredientView.widthAnchor.constraint(equalToConstant: widthOfCardImageView)
            //            cardGredientView.heightAnchor.constraint(equalToConstant: heightOfCardImageView > widthOfCardImageView ? widthOfCardImageView : heightOfCardImageView),
            //            cardGredientView.widthAnchor.constraint(equalToConstant: heightOfCardImageView > widthOfCardImageView ? widthOfCardImageView : heightOfCardImageView)
        ])
        //        cardGredientView.layer.cornerRadius = (heightOfCardImageView > widthOfCardImageView ? widthOfCardImageView : heightOfCardImageView) / 2
        cardGredientView.layer.cornerRadius = (widthOfCardImageView) / 2
        cardGredientView.clipsToBounds = true
        //        scratchCard.layer.cornerRadius = (heightOfCardImageView > widthOfCardImageView ? widthOfCardImageView : heightOfCardImageView) / 2
        scratchCard.layer.cornerRadius = (widthOfCardImageView) / 2
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
        if yogaFertilityPositionElement.isScratched {
            cardGredientView.hero.id = "gredientYogaCardImageHeroID\(selectedCardIndex)"
            scratchCard.isHidden = true
            self.resetButtonDidableView.isHidden = true
        } else {
            scratchCard.hero.id = "gredientYogaCardImageHeroID\(selectedCardIndex)"
            scratchCard.isHidden = false
            cardGredientView.isHidden = true
        }
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
            resetButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: DeviceSize.isiPadDevice ? -28 : -20),
        ])
        
        view.addSubview(resetButtonDidableView)
        resetButtonDidableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetButtonDidableView.topAnchor.constraint(equalTo: resetButton.topAnchor),
            resetButtonDidableView.leadingAnchor.constraint(equalTo: resetButton.leadingAnchor),
            resetButtonDidableView.trailingAnchor.constraint(equalTo: resetButton.trailingAnchor),
            resetButtonDidableView.bottomAnchor.constraint(equalTo: resetButton.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.removeFromSuperview()
        tableView.layoutIfNeeded()
        tableView.layoutSubviews()
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(YogaDetailTaskTBLCell.self, forCellReuseIdentifier: "YogaDetailTaskTBLCell")
        view.addSubview(tableView)
        setupButtons()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cardGredientView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: 20)
        ])
        tableView.reloadData()
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
                
                self.yogaFertilityPositionElement.isScratched = true
                self.resetButtonDidableView.isHidden = true
                if let action = self.saveAfterScratcingCard {
                    action()
                }
                // Start the image loop if there are multiple images
                if yogaFertilityPositionElement.images.count > 1 {
                    startImageLoop()
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
extension YogaDetailVC {
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    @objc func resetButtonTapped(sender: UIButton) {
        sender.showAnimation(isForError: true) {
            self.yogaFertilityPositionElement.isScratched = false
            self.handleScratchViewHidden()
            self.resetButtonDidableView.isHidden = false
            if let action = self.saveAfterScratcingCard {
                action()
            }
            self.imageChangeTimer?.invalidate()
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension YogaDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let label = CommonView.getCommonLabel(text: self.yogaFertilityPositionElement.title, font: .boldSystemFont(ofSize: 20.pulse2Font()))
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YogaDetailTaskTBLCell", for: indexPath) as! YogaDetailTaskTBLCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        switch indexPath.row {
        case 0:
            cell.setUpCell(detailHeadlineText: "YogaVC.PostionsDetails.Where.headline.text"~, detailSubtitleText: yogaFertilityPositionElement.whereText)
            break
        case 1:
            cell.setUpCell(detailHeadlineText: "YogaVC.PostionsDetails.Why.headline.text"~, detailSubtitleText: yogaFertilityPositionElement.whyText)
            break
        case 2:
            cell.setUpCell(detailHeadlineText: "YogaVC.PostionsDetails.How.headline.text"~, detailSubtitleText: yogaFertilityPositionElement.howText)
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
