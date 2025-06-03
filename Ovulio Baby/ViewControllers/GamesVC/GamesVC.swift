//
//  GamesVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-19.
//

import UIKit
//import ScreenShield


class GamesVC: UIViewController {
    
    var gamesData = GamesModel()
    var customNavBarView: CustomNavigationBar?
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var scoreLabel = UILabel()
    let scoreProgressBar = UIProgressView()
    let scorePercentageLabel = CommonView.getCommonLabel(text: "", textColor: lightAppColor, font: .systemFont(ofSize: 12.pulse2Font()))
    let numberOfCardsLabel = CommonView.getCommonLabel(text: "", font: .boldSystemFont(ofSize: 20.pulse2Font()))
    var legsUpScreenIsNeededToShow: (() -> Void)?
    
    var UnlockForMoreFunButton: UIButton = {
        let button = UIButton()
        button.setTitle("GamesVC.UnlockForMoreFunButton.Extras.title"~, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = buttonAppLightColor
        button.layer.cornerRadius = 15
        button.layer.shadowColor = appColor?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        return button
    }()
    
    let illustrationImageView = UIImageView()
    var illustrationImageViewFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gamesData = GamesDataManager.shared.retrieveGamesModel(){
            self.gamesData = gamesData
        }
//        else{
//            GamesDataManager.shared.setUpGameData()
//            if let gamesData = GamesDataManager.shared.retrieveGamesModel() {
//                self.gamesData = gamesData
//            }
//        }
        self.view.setUpBackground()
        setUpNavigationBar()
        setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Protect ScreenShot
        //ScreenShield.shared.protect(view: self.view)
        
        // Protect Screen-Recording
        //ScreenShield.shared.protectFromScreenRecording()
        
        self.delay(1.0) {
            
            self.startPulsingUnlockForMoreFunButton()
            
        }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func startPulsingUnlockForMoreFunButton() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 1.0
        pulse.toValue = 1.03
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        let pulseGroup = CAAnimationGroup()
        pulseGroup.duration = 3.0
        pulseGroup.repeatCount = .infinity
        pulseGroup.animations = [pulse]
        
        self.UnlockForMoreFunButton.layer.add(pulseGroup, forKey: "pulse")
        
    }
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            titleString: "GamesVC.headlineLabel.text"~
        )
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                self.dismiss(animated: true) {
                    if GamesDataManager.shared.needToShowLegsUpScreen ?? false {
                        if let action = self.legsUpScreenIsNeededToShow {
                            action()
                        }
                    }
                }
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
        tableView.register(LevelsAndCardsCell.self, forCellReuseIdentifier: "LevelsAndCardsCell")
        tableView.register(GamesLocaionsCell.self, forCellReuseIdentifier: "GamesLocaionsCell")
        tableView.register(GamesExtrasPlaceCell.self, forCellReuseIdentifier: "GamesExtrasPlaceCell")
        view.addSubview(tableView)
        if let customNavBarView = customNavBarView {
            tableView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        }else{
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
        ])
        tableView.reloadData()
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension GamesVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return gamesData.extras?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LevelsAndCardsCell", for: indexPath) as! LevelsAndCardsCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.cardDidTapped = { levelIndex, cardIndex in
                
                var isCardLocked = false
                switch levelIndex {
                case 0:
                    isCardLocked = (!isUserProMember() && cardIndex >= 4)
                    break
                case 1:
                    isCardLocked = (!isUserProMember() && cardIndex >= 3)
                    break
                case 2:
                    isCardLocked = (!isUserProMember() && cardIndex >= 2)
                    break
                case 3:
                    isCardLocked = (!isUserProMember() && cardIndex >= 1)
                    break
                case 4:
                    isCardLocked = (!isUserProMember() && cardIndex >= 1)
                    break
                case 5:
                    isCardLocked = (!isUserProMember() && cardIndex >= -1)
                    break
                default:
                    break
                }
                
                if isCardLocked {
                    
                    // Success
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    let vc = SalesVC()
                    vc.didPurchaseSuccessfully = {
                        self.viewDidLoad()
                    }
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .coverVertical
                    self.present(vc, animated: true, completion: nil)
                    return
                }
                
                let vc = GameCardScrachVC()
                vc.levelData = self.gamesData.gameLevels?[levelIndex]
                vc.hero.isEnabled = true
                vc.selectedCardIndex = cardIndex
                vc.doneButtonTapped = {
                    GamesDataManager.shared.saveGamesModel(self.gamesData)
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    cell.cardsCollectionView.reloadItems(at: [IndexPath(item: cardIndex, section: 0)])
                    //                    }
                    
                    let (earnScore, totalScore) = self.calculateTotalPointsAndCardPoints()
                    self.scoreLabel.text = "\(earnScore)/\(totalScore)"
                    self.scorePercentageLabel.text = "\(Int(Double(earnScore) / Double(totalScore) * 100))%"
                    self.scoreProgressBar.progress = Float(Double(earnScore) / Double(totalScore))
                    let (totalCards, scratchedCards) = self.calculateTotalCardsAndScratchedCards()
                    self.numberOfCardsLabel.text = "\(scratchedCards)/\(totalCards)"
                    
                }
                
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
                
            }
            
            cell.setUpCell(gameLevels: self.gamesData.gameLevels)
            
            if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == false {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GamesLocaionsCell", for: indexPath) as! GamesLocaionsCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.locationGetsCompleted = {
                GamesDataManager.shared.saveGamesModel(self.gamesData)
                let (earnScore, totalScore) = self.calculateTotalPointsAndCardPoints()
                self.scoreLabel.text = "\(earnScore)/\(totalScore)"
                self.scorePercentageLabel.text = "\(Int(Double(earnScore) / Double(totalScore) * 100))%"
                self.scoreProgressBar.progress = Float(Double(earnScore) / Double(totalScore))
            }
            cell.UnlockForMoreFunButtonTap = {
                let vc = SalesVC()
                vc.didPurchaseSuccessfully = {
                    self.viewDidLoad()
                }
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
            }
            cell.setUpCell(locations: self.gamesData.locations)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GamesExtrasPlaceCell", for: indexPath) as! GamesExtrasPlaceCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.setUpCell(extrasData: gamesData.extras?[indexPath.row])
            cell.isUserInteractionEnabled = true
            
            if !isUserProMember() {
                if indexPath.row >= 3 {
                    cell.setupblurView()
                }
            }
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let indexPath = IndexPath(row: 7, section: 3)
        let targetIndexPath = IndexPath(row: 7, section: 3)

        if let cellFrame = tableView.rectForRow(at: indexPath) as? CGRect {
            
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
                if visibleIndexPaths.contains(targetIndexPath) {
                    if !isUserProMember() && !illustrationImageViewFirstTime {
                        tableView.addSubview(self.UnlockForMoreFunButton)
                        self.UnlockForMoreFunButton.addTarget(self, action: #selector(self.touchDownButtonAction(_:)), for: .touchDown)
                        self.UnlockForMoreFunButton.addTarget(self, action: #selector(self.touchUpButtonAction(_:)), for: .touchUpOutside)
                        self.UnlockForMoreFunButton.addTarget(self, action: #selector(self.UnlockForMoreFunButtonTapped), for: .touchUpInside)
                        self.UnlockForMoreFunButton.frame = CGRect(x: DeviceSize.isiPadDevice ? (cellFrame.midX / 2) : 20, y: cellFrame.minY, width: DeviceSize.isiPadDevice ? (ScreenSize.width / 2) : (ScreenSize.width - 40), height: 55)
                        
                        
                        self.illustrationImageView.image = UIImage(named: "sexLocationsIllustration")!
                        self.illustrationImageView.contentMode = .scaleAspectFit
                        tableView.addSubview(self.illustrationImageView)
                        self.illustrationImageView.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            self.illustrationImageView.bottomAnchor.constraint(equalTo: self.UnlockForMoreFunButton.topAnchor, constant: -10),
                            self.illustrationImageView.centerXAnchor.constraint(equalTo: self.UnlockForMoreFunButton.centerXAnchor),
                            self.illustrationImageView.heightAnchor.constraint(equalToConstant: 170),
                            self.illustrationImageView.widthAnchor.constraint(equalToConstant: self.UnlockForMoreFunButton.widthOfView * 0.8)
                        ])
                    }else{
                        illustrationImageViewFirstTime = false
                    }
                }
            }
            
        }
        
    }
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    @objc func UnlockForMoreFunButtonTapped(sender: UIButton) {
        
        sender.showAnimation {
            let vc = SalesVC()
            vc.didPurchaseSuccessfully = {
                self.viewDidLoad()
            }
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 0
        case 1:
            
            if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == false {
                return 0.0
            }
            
            return UITableView.automaticDimension
        case 2:
            if indexPath.section == 2 {
                var height = 0
                if let locations = gamesData.locations{
                    for location in locations {
                        height += location.places.count * 40
                        height += 60
                    }
                }
                return CGFloat(height)
            }
            return UITableView.automaticDimension
        case 3:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            return createHeaderForScoreAndScrachedCards()
        case 1:
            return createHeaderForLevelsAndCards()
        case 2:
            return createHeaderForLocations()
        case 3:
            return createHeaderForExtras()
        default:
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isUserProMember() {
            if indexPath.section == 3 && indexPath.row >= 3 {
                
                // Success
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                let vc = SalesVC()
                vc.didPurchaseSuccessfully = {
                    self.viewDidLoad()
                }
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
        
        if indexPath.section == 3 {
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.showAnimation({
                if self.gamesData.extras?[indexPath.row].isAlreadyCompleted ?? false{
                    self.gamesData.extras?[indexPath.row].isAlreadyCompleted = false
                }else{
                    self.gamesData.extras?[indexPath.row].isAlreadyCompleted = true
                }
                GamesDataManager.shared.saveGamesModel(self.gamesData)
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            })
            
        }
        
    }
    
    private func createHeaderForScoreAndScrachedCards() -> UIView {
        
        let headerView = UIView()
        
        let scoreView = CommonView.getViewWithShadowAndRadius()
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrachedCardView = CommonView.getViewWithShadowAndRadius()
        scrachedCardView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(scoreView)
        headerView.addSubview(scrachedCardView)
        
        NSLayoutConstraint.activate([
            scoreView.topAnchor.constraint(equalTo: headerView.topAnchor),
            scoreView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            scoreView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.5, constant: -25),
            scoreView.heightAnchor.constraint(equalTo: headerView.heightAnchor),
            
            scrachedCardView.topAnchor.constraint(equalTo: headerView.topAnchor),
            scrachedCardView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            scrachedCardView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.5, constant: -25),
            scrachedCardView.heightAnchor.constraint(equalTo: headerView.heightAnchor),
        ])
        
        let yourScoreStatiLabel = CommonView.getCommonLabel(text: "GamesVC.ScoreAndCardsHeader.scoreView.headlineLabel.text"~, textColor: lightAppColor, font: .systemFont(ofSize: 16.pulse2Font()))
        scoreView.addSubview(yourScoreStatiLabel)
        NSLayoutConstraint.activate([
            yourScoreStatiLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor, constant: 20),
            yourScoreStatiLabel.topAnchor.constraint(equalTo: scoreView.topAnchor, constant: 20),
            yourScoreStatiLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor, constant: -20),
        ])
        let (earnScore, totalScore) = calculateTotalPointsAndCardPoints()
        let scoreQuoteLabel = CommonView.getCommonLabel(text: getScoreRewardString(points: earnScore), font: .boldSystemFont(ofSize: 20.pulse2Font()))
        scoreView.addSubview(scoreQuoteLabel)
        NSLayoutConstraint.activate([
            scoreQuoteLabel.leadingAnchor.constraint(equalTo: yourScoreStatiLabel.leadingAnchor),
            scoreQuoteLabel.topAnchor.constraint(equalTo: yourScoreStatiLabel.bottomAnchor, constant: 15),
            scoreQuoteLabel.trailingAnchor.constraint(equalTo: yourScoreStatiLabel.trailingAnchor),
        ])
        
        scoreView.addSubview(scoreProgressBar)
        scoreProgressBar.translatesAutoresizingMaskIntoConstraints = false
        scoreProgressBar.tintColor = UIColor(hexString: "FFC42C")
        scoreProgressBar.layer.cornerRadius = 2.5
        self.scoreProgressBar.progress = Float(Double(earnScore) / Double(totalScore))
        NSLayoutConstraint.activate([
            scoreProgressBar.leadingAnchor.constraint(equalTo: yourScoreStatiLabel.leadingAnchor),
            scoreProgressBar.topAnchor.constraint(equalTo: scoreQuoteLabel.bottomAnchor, constant: 5),
            scoreProgressBar.trailingAnchor.constraint(equalTo: yourScoreStatiLabel.trailingAnchor),
            scoreProgressBar.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        scoreLabel = CommonView.getCommonLabel(text: "\(earnScore)/\(totalScore)", textColor: lightAppColor, font: .systemFont(ofSize: 12.pulse2Font()))
        scoreView.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: yourScoreStatiLabel.leadingAnchor),
            scoreLabel.topAnchor.constraint(equalTo: scoreProgressBar.bottomAnchor, constant: 5),
            scoreLabel.trailingAnchor.constraint(equalTo: yourScoreStatiLabel.trailingAnchor, constant: 50),
            scoreLabel.bottomAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: -20),
        ])
        
        self.scorePercentageLabel.text = calculatePercentage(earnScore: earnScore, totalScore: totalScore)
        scoreView.addSubview(scorePercentageLabel)
        NSLayoutConstraint.activate([
            scorePercentageLabel.topAnchor.constraint(equalTo: scoreProgressBar.bottomAnchor, constant: 5),
            scorePercentageLabel.trailingAnchor.constraint(equalTo: yourScoreStatiLabel.trailingAnchor),
        ])
        let cardScrachedStatiLabel = CommonView.getCommonLabel(text: "GamesVC.ScoreAndCardsHeader.cardView.headlineLabel.text"~, textColor: lightAppColor, font: .systemFont(ofSize: 16.pulse2Font()), lines: 0)
        scrachedCardView.addSubview(cardScrachedStatiLabel)
        NSLayoutConstraint.activate([
            cardScrachedStatiLabel.leadingAnchor.constraint(equalTo: scrachedCardView.leadingAnchor, constant: 20),
            cardScrachedStatiLabel.topAnchor.constraint(equalTo: scrachedCardView.topAnchor, constant: 20),
            cardScrachedStatiLabel.trailingAnchor.constraint(equalTo: scrachedCardView.trailingAnchor, constant: -20),
        ])
        let cardGredientImageView = CommonView.getCommonImageView(image: "positionCardGredientIMG")
        scrachedCardView.addSubview(cardGredientImageView)
        NSLayoutConstraint.activate([
            cardGredientImageView.leadingAnchor.constraint(equalTo: cardScrachedStatiLabel.leadingAnchor),
            cardGredientImageView.topAnchor.constraint(equalTo: cardScrachedStatiLabel.bottomAnchor, constant: 20),
            cardGredientImageView.heightAnchor.constraint(equalTo: scrachedCardView.widthAnchor, multiplier: 0.1),
            cardGredientImageView.widthAnchor.constraint(equalTo: scrachedCardView.widthAnchor, multiplier: 0.1),
        ])
        let (totalCards, scratchedCards) = calculateTotalCardsAndScratchedCards()
        numberOfCardsLabel.text = "\(scratchedCards)/\(totalCards)"
        scrachedCardView.addSubview(numberOfCardsLabel)
        NSLayoutConstraint.activate([
            numberOfCardsLabel.leadingAnchor.constraint(equalTo: cardGredientImageView.trailingAnchor, constant: 5),
            numberOfCardsLabel.centerYAnchor.constraint(equalTo: cardGredientImageView.centerYAnchor),
            numberOfCardsLabel.trailingAnchor.constraint(equalTo: scrachedCardView.trailingAnchor, constant: -15),
        ])
        
        return headerView
        
    }
    
    func calculatePercentage(earnScore: Int, totalScore: Int) -> String {
        
        // Ensure totalScore is not zero to avoid division by zero
        guard totalScore != 0 else {
            return "0%"
        }
        
        // Perform the calculation and return the result
        let percentage = Int(Double(earnScore) / Double(totalScore) * 100)
        return "\(percentage)%"
        
    }
    
    func getScoreRewardString(points: Int) -> String {
        
        let reward: String
        switch ProfileDataManager.shared.selectedGender {
        case .boy:
            switch points {
            case 0...60:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.Novice.text"~
            case 61...120:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.Experienced.text"~
            case 121...200:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.Expert.text"~
            case 201...280:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.SeductionMaster.text"~
            case 281...380:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.KingOfLust.text"~
            default:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.SexGod.text"~
            }
        case .girl:
            switch points {
            case 0...40:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.Novice.text"~
            case 41...80:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.Experienced.text"~
            case 81...120:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.Expert.text"~
            case 121...160:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.SeductionMaster.text"~
            case 161...200:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.KingOfLust.text"~
            default:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.SexGod.text"~
            }
        default: // Gender doesn't matter
            switch points {
            case 0...80:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.Novice.text"~
            case 81...180:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.Experienced.text"~
            case 181...280:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.Expert.text"~
            case 281...380:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.SeductionMaster.text"~
            case 381...500:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.KingOfLust.text"~
            default:
                reward = "GamesVC.ScoreAndCardsHeader.scoreView.quote.SexGod.text"~
            }
        }
        
        return reward
        
    }
    
    private func createHeaderForLevelsAndCards() -> UIView {
        
        let headerView = UIView()
        let headlineLabel = CommonView.getCommonLabel(text: "GamesVC.LevelsAndPositionCardsHeader.headlineLabel.text"~, font: .boldSystemFont(ofSize: 24.pulse2Font()), lines: 0, alignment: .center)
        headerView.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headlineLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            headlineLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            headlineLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == false {
            headerView.isHidden = true
        } else {
            headerView.isHidden = false
        }
        
        return headerView
        
    }
    
    private func createHeaderForLocations() -> UIView {
        
        let headerView = UIView()
        let headlineLabel = CommonView.getCommonLabel(text: "GamesVC.LocationsHeader.headlineLabel.text"~, font: .boldSystemFont(ofSize: 20.pulse2Font()), alignment: .center)
        headerView.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headlineLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            headlineLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
        ])
        let headlineDescriptionLabel = CommonView.getCommonLabel(text: "GamesVC.LocationsHeader.headlineDescriptionLabel.text"~, font: .systemFont(ofSize: 14.pulse2Font()), lines: 0, alignment: .center)
        headerView.addSubview(headlineDescriptionLabel)
        NSLayoutConstraint.activate([
            headlineDescriptionLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor, constant: 20),
            headlineDescriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 5),
            headlineDescriptionLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor, constant: -20),
            headlineDescriptionLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
        
    }
    
    private func createHeaderForExtras() -> UIView {
        
        let headerView = UIView()
        let headlineLabel = CommonView.getCommonLabel(text: "GamesVC.ExtrasHeader.headlineLabel.text"~, font: .boldSystemFont(ofSize: 20.pulse2Font()), alignment: .center)
        headerView.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headlineLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            headlineLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
        ])
        let headlineDescriptionLabel = CommonView.getCommonLabel(text: "GamesVC.ExtrasHeader.headlineDescriptionLabel.text"~, font: .systemFont(ofSize: 14.pulse2Font()), lines: 0, alignment: .center)
        headerView.addSubview(headlineDescriptionLabel)
        NSLayoutConstraint.activate([
            headlineDescriptionLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor, constant: 20),
            headlineDescriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 5),
            headlineDescriptionLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor, constant: -20),
            headlineDescriptionLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15)
        ])
        
        return headerView
        
    }
    
    func calculateTotalPointsAndCardPoints() -> (Int, Int) {
        
        var totalPoints = 0
        var sumOfCardPoints = 0
        // For Cards
        if let gameLevels = gamesData.gameLevels{
            for level in gameLevels {
                for card in level.cards where card.isAlreadyScrached {
                    sumOfCardPoints += level.pointPerCard
                }
                totalPoints += level.cards.count * level.pointPerCard
            }
        }
        // For Locations
        if let locations = gamesData.locations{
            for loc in locations {
                for place in loc.places {
                    if place.isAlreadyCompleted {
                        sumOfCardPoints += place.points
                    }
                    totalPoints += place.points
                }
            }
        }
        // For Extras
        if let extras = gamesData.extras{
            for extr in extras {
                if extr.isAlreadyCompleted {
                    sumOfCardPoints += extr.points
                }
                totalPoints += extr.points
            }
        }
        
        return (sumOfCardPoints, totalPoints)
        
    }
    
    func calculateTotalCardsAndScratchedCards() -> (Int, Int) {
        
        var totalCards = 0
        var scratchedCards = 0
        if let gameLevels = gamesData.gameLevels {
            
            for level in gameLevels {
                
                totalCards += level.cards.count
                for card in level.cards {
                    if card.isAlreadyScrached {
                        scratchedCards += 1
                    }
                }
                
            }
            
        }
        
        return (totalCards, scratchedCards)
        
    }
    
}
