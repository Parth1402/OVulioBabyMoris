//
//  LearningResourceArticleVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-12.
//

import UIKit
import Hero

enum ArticleName: CaseIterable {
    case ohBaby
    case theRoadBeforeTheBump
    case chineseConceptionCalendar
    case positionPerfect
    case babyliciousNutritious
    case fertilityCalendar
    case waysToShowYour
    case hitTheGym
    case howToSupportYourPartner
    case ohBabySexAfterChildbirth
}

class LearningResourceArticleVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    var articleTableView = UITableView(frame: CGRect.zero, style: .grouped)
    var UnlockForMoreFunButton: UIButton = {
        let button = UIButton()
        button.setTitle("LearningResourcesVC.UnlockForMoreFunButton.Masterclass.title"~, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = buttonAppLightColor
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = appColor?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        return button
    }()
    let continueButtonGradientImageView = CommonView.getCommonImageView(image: "Gradient View IAP Menu Purchase Button")
    
    enum ArticleSection {
        case headline(text: String)
        case headlineText(text: String)
        case sectionHeadline(text: String)
        case text(text: String)
    }
    
    var selectedArticleName: ArticleName?
    var selectedArticleImageName: String?
    var selectedCellItemIndex: Int?
    
    var articleSections: [ArticleSection] = []
    
    override func viewDidLoad() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.view.backgroundColor = .white
//        self.hero.isEnabled = true
        setUpNavigationBar()
        setupArticleContent()
        
        if !isUserProMember() {
            view.addSubview(continueButtonGradientImageView)
            self.view.addSubview(UnlockForMoreFunButton)
            // Button Animation
            UnlockForMoreFunButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
            UnlockForMoreFunButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
            UnlockForMoreFunButton.addTarget(self, action:#selector(UnlockForMoreFunButtonTapped), for: .touchUpInside)
            NSLayoutConstraint.activate([
                UnlockForMoreFunButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                UnlockForMoreFunButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding),
                UnlockForMoreFunButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding),
                UnlockForMoreFunButton.heightAnchor.constraint(equalToConstant: 55)
            ])
            UnlockForMoreFunButton.layer.shadowColor = appColor?.cgColor
            UnlockForMoreFunButton.layer.shadowOffset = CGSize(width: 0, height: 8)
            UnlockForMoreFunButton.layer.shadowOpacity = 0.7
            UnlockForMoreFunButton.layer.shadowRadius = 8
            NSLayoutConstraint.activate([
                continueButtonGradientImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                continueButtonGradientImageView.topAnchor.constraint(equalTo: UnlockForMoreFunButton.topAnchor, constant: -22),
                continueButtonGradientImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                continueButtonGradientImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            UnlockForMoreFunButton.layer.shadowColor = appColor?.cgColor
            UnlockForMoreFunButton.layer.shadowOffset = CGSize(width: 0, height: 8)
            UnlockForMoreFunButton.layer.shadowOpacity = 0.7
            UnlockForMoreFunButton.layer.shadowRadius = 8
            NSLayoutConstraint.activate([
                continueButtonGradientImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                continueButtonGradientImageView.topAnchor.constraint(equalTo: UnlockForMoreFunButton.topAnchor, constant: -22),
                continueButtonGradientImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                continueButtonGradientImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
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
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            titleString: "LearningResourceArticleVC.headlineLabel.text"~
        )
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
    }
    
    func setupArticleContent() {
        switch selectedArticleName {
        case .ohBaby:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.ohBaby.headline"~),
                .headlineText(text: "LearningResourceArticleVC.ohBaby.text"~),
                .sectionHeadline(text: "LearningResourceArticleVC.ohBaby.section1.headline"~),
                .text(text: "LearningResourceArticleVC.ohBaby.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.ohBaby.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.ohBaby.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.ohBaby.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.ohBaby.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.ohBaby.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.ohBaby.section4.text"~),
                ])
            }
            break
        case .theRoadBeforeTheBump:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.theRoadBeforeTheBump.headline"~),
                .headlineText(text: "LearningResourceArticleVC.theRoadBeforeTheBump.text"~),
                .sectionHeadline(text: "LearningResourceArticleVC.theRoadBeforeTheBump.section1.headline"~),
                .text(text: "LearningResourceArticleVC.theRoadBeforeTheBump.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.theRoadBeforeTheBump.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.theRoadBeforeTheBump.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.theRoadBeforeTheBump.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.theRoadBeforeTheBump.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.theRoadBeforeTheBump.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.theRoadBeforeTheBump.section4.text"~),
                ])
            }
            break
        case .chineseConceptionCalendar:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.chineseConceptionCalendar.headline"~),
                .sectionHeadline(text: "LearningResourceArticleVC.chineseConceptionCalendar.section1.headline"~),
                .text(text: "LearningResourceArticleVC.chineseConceptionCalendar.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.chineseConceptionCalendar.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.chineseConceptionCalendar.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.chineseConceptionCalendar.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.chineseConceptionCalendar.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.chineseConceptionCalendar.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.chineseConceptionCalendar.section4.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.chineseConceptionCalendar.section5.headline"~),
                    .text(text: "LearningResourceArticleVC.chineseConceptionCalendar.section5.text"~),
                ])
            }
            break
        case .positionPerfect:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.positionPerfect.headline"~),
                .headlineText(text: "LearningResourceArticleVC.ohBaby.text"~),
                .sectionHeadline(text: "LearningResourceArticleVC.positionPerfect.section1.headline"~),
                .text(text: "LearningResourceArticleVC.positionPerfect.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.positionPerfect.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.positionPerfect.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.positionPerfect.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.positionPerfect.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.positionPerfect.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.positionPerfect.section4.text"~),
                ])
            }
            break
        case .babyliciousNutritious:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.babyliciousNutritious.headline"~),
                .headlineText(text: "LearningResourceArticleVC.babyliciousNutritious.headline.text"~),
                .sectionHeadline(text: "LearningResourceArticleVC.babyliciousNutritious.section1.headline"~),
                .text(text: "LearningResourceArticleVC.babyliciousNutritious.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.babyliciousNutritious.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.babyliciousNutritious.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.babyliciousNutritious.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.babyliciousNutritious.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.babyliciousNutritious.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.babyliciousNutritious.section4.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.babyliciousNutritious.section5.headline"~),
                    .text(text: "LearningResourceArticleVC.babyliciousNutritious.section5.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.babyliciousNutritious.section6.headline"~),
                    .text(text: "LearningResourceArticleVC.babyliciousNutritious.section6.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.babyliciousNutritious.section7.headline"~),
                    .text(text: "LearningResourceArticleVC.babyliciousNutritious.section7.text"~),
                ])
            }
            break
        case .fertilityCalendar:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.fertilityCalendar.headline"~),
                .headlineText(text: "LearningResourceArticleVC.fertilityCalendar.text"~),
                .sectionHeadline(text: "LearningResourceArticleVC.fertilityCalendar.section1.headline"~),
                .text(text: "LearningResourceArticleVC.fertilityCalendar.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.fertilityCalendar.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.fertilityCalendar.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.fertilityCalendar.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.fertilityCalendar.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.fertilityCalendar.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.fertilityCalendar.section4.text"~),
                ])
            }
            break
        case .waysToShowYour:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.waysToShowYour.headline"~),
                .headlineText(text: "LearningResourceArticleVC.waysToShowYour.text"~),
                .sectionHeadline(text: "LearningResourceArticleVC.waysToShowYour.section1.headline"~),
                .text(text: "LearningResourceArticleVC.waysToShowYour.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.waysToShowYour.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.waysToShowYour.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.waysToShowYour.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.waysToShowYour.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.waysToShowYour.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.waysToShowYour.section4.text"~),
                ])
            }
            break
        case .hitTheGym:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.hitTheGym.headline"~),
                .headlineText(text: "LearningResourceArticleVC.hitTheGym.text"~),
                .sectionHeadline(text: "LearningResourceArticleVC.hitTheGym.section1.headline"~),
                .text(text: "LearningResourceArticleVC.hitTheGym.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.hitTheGym.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.hitTheGym.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.hitTheGym.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.hitTheGym.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.hitTheGym.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.hitTheGym.section4.text"~),
                ])
            }
            break
        case .howToSupportYourPartner:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.howToSupportYourPartner.headline"~),
                .headlineText(text: "LearningResourceArticleVC.howToSupportYourPartner.text"~),
                .sectionHeadline(text: "LearningResourceArticleVC.howToSupportYourPartner.section1.headline"~),
                .text(text: "LearningResourceArticleVC.howToSupportYourPartner.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.howToSupportYourPartner.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.howToSupportYourPartner.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.howToSupportYourPartner.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.howToSupportYourPartner.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.howToSupportYourPartner.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.howToSupportYourPartner.section4.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.howToSupportYourPartner.section5.headline"~),
                    .text(text: "LearningResourceArticleVC.howToSupportYourPartner.section5.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.howToSupportYourPartner.section6.headline"~),
                    .text(text: "LearningResourceArticleVC.howToSupportYourPartner.section6.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.howToSupportYourPartner.section7.headline"~),
                    .text(text: "LearningResourceArticleVC.howToSupportYourPartner.section7.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.howToSupportYourPartner.section8.headline"~),
                    .text(text: "LearningResourceArticleVC.howToSupportYourPartner.section8.text"~),
                ])
            }
            break
        case .ohBabySexAfterChildbirth:
            articleSections = [
                .headline(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.headline"~),
                .headlineText(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.text"~),
                .sectionHeadline(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section1.headline"~),
                .text(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section1.text"~),
            ]
            if isUserProMember() {
                articleSections.append(contentsOf: [
                    .sectionHeadline(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section2.headline"~),
                    .text(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section2.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section3.headline"~),
                    .text(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section3.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section4.headline"~),
                    .text(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section4.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section5.headline"~),
                    .text(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section5.text"~),
                    .sectionHeadline(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section6.headline"~),
                    .text(text: "LearningResourceArticleVC.ohBabySexAfterChildbirth.section6.text"~),
                ])
            }
            break
        case .none:
            break
        }
        setupArticleTableView()
    }
    
    func setupArticleTableView() {
        articleTableView.removeFromSuperview()
        articleTableView = UITableView(frame: CGRect.zero, style: .grouped)
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.separatorStyle = .none
        articleTableView.backgroundColor = .clear
        articleTableView.rowHeight = UITableView.automaticDimension
        articleTableView.showsVerticalScrollIndicator = false
        articleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        articleTableView.register(ArticleDetailTextCell.self, forCellReuseIdentifier: "ArticleDetailTextCell")
        view.addSubview(articleTableView)
        if let customNavBarView = customNavBarView {
            articleTableView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        }else{
            articleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        NSLayoutConstraint.activate([
            articleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.isiPadDevice ? ScreenSize.width * 0.2 : 15),
            articleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -15),
            articleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        articleTableView.reloadData()
    }
}

extension LearningResourceArticleVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return articleSections.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleDetailTextCell", for: indexPath) as! ArticleDetailTextCell
        cell.selectionStyle = .none
        
        let section = articleSections[indexPath.row]
        switch section {
        case .headline(let text):
            cell.atricleTextLabel.font = UIFont.boldSystemFont(ofSize: 24)
            cell.atricleTextLabel.textColor = appColor
            cell.seuUpCell(text: text)
            break
        case .headlineText(let text):
            cell.atricleTextLabel.font = UIFont.systemFont(ofSize: 14.pulse2Font())
            cell.atricleTextLabel.textColor = appColor
            cell.seuUpCell(text: text)
            break
        case .sectionHeadline(let text):
            cell.atricleTextLabel.font = UIFont.mymediumSystemFont(ofSize: 17.pulse2Font())
            cell.atricleTextLabel.textColor = appColor
            cell.seuUpCell(text: "\n" + text)
            if !isUserProMember() {
                cell.setupGradientView(colors: [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.withAlphaComponent(0.2).cgColor, UIColor.white.withAlphaComponent(0.4).cgColor, UIColor.white.withAlphaComponent(0.55).cgColor])
            }
            break
        case .text(let text):
            cell.atricleTextLabel.font = UIFont.systemFont(ofSize: 14.pulse2Font())
            cell.atricleTextLabel.textColor = appColor
            cell.seuUpCell(text: text)
            if !isUserProMember() {
                cell.setupGradientView(colors: [UIColor.white.withAlphaComponent(0.65).cgColor, UIColor.white.withAlphaComponent(0.78).cgColor, UIColor.white.withAlphaComponent(0.92).cgColor, UIColor.white.withAlphaComponent(1).cgColor])
            }
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isUserProMember() {
            var readFullContainer = UIView()
            var desireRow = -1
            if selectedArticleName == .chineseConceptionCalendar {
                desireRow = 2
            }else{
                desireRow = 3
            }
            if indexPath == IndexPath(row: desireRow, section: 1) {
                DispatchQueue.main.async {
                    if let cellFrame = tableView.rectForRow(at: indexPath) as? CGRect{
                        readFullContainer.frame = CGRect(x: 0, y: cellFrame.minY + 120, width: cellFrame.width, height: 500)
                        readFullContainer.backgroundColor = .white
                        tableView.addSubview(readFullContainer)
                        tableView.contentInset = .init(top: 0, left: 0, bottom: 600, right: 0)
                        
                        let readMasterclassIMG = CommonView.getCommonImageView(image: "readMasterclassIMG")
                        readMasterclassIMG.clipsToBounds = true
                        readMasterclassIMG.contentMode = .scaleAspectFill
                        readFullContainer.addSubview(readMasterclassIMG)
                        NSLayoutConstraint.activate([
                            readMasterclassIMG.centerXAnchor.constraint(equalTo: readFullContainer.centerXAnchor),
                            readMasterclassIMG.topAnchor.constraint(equalTo: readFullContainer.topAnchor),
                            readMasterclassIMG.widthAnchor.constraint(equalTo: readFullContainer.widthAnchor),
                            readMasterclassIMG.heightAnchor.constraint(equalTo: readFullContainer.heightAnchor, multiplier: 0.5)
                        ])
                        
                        let headlineReadMasterLabel = CommonView.getCommonLabel(text: "LearningResourceArticleVC.ReadFullMasterclass.headline.text"~, font: .boldSystemFont(ofSize: 24), alignment: .center)
                        headlineReadMasterLabel.adjustsFontSizeToFitWidth = true
                        headlineReadMasterLabel.minimumScaleFactor = 0.2
                        readFullContainer.addSubview(headlineReadMasterLabel)
                        NSLayoutConstraint.activate([
                            headlineReadMasterLabel.leadingAnchor.constraint(equalTo: readFullContainer.leadingAnchor),
                            headlineReadMasterLabel.trailingAnchor.constraint(equalTo: readFullContainer.trailingAnchor),
                            headlineReadMasterLabel.topAnchor.constraint(equalTo: readMasterclassIMG.bottomAnchor, constant: DeviceSize.isiPadDevice ? 10 : 0),
                        ])
                        
                        let subTitleReadMasterLabel = CommonView.getCommonLabel(text: "LearningResourceArticleVC.ReadFullMasterclass.subtitle.text"~, font: .systemFont(ofSize: 14.pulse2Font()), lines: 0, alignment: .center)
                        readFullContainer.addSubview(subTitleReadMasterLabel)
                        NSLayoutConstraint.activate([
                            subTitleReadMasterLabel.leadingAnchor.constraint(equalTo: readFullContainer.leadingAnchor),
                            subTitleReadMasterLabel.trailingAnchor.constraint(equalTo: readFullContainer.trailingAnchor),
                            subTitleReadMasterLabel.topAnchor.constraint(equalTo: headlineReadMasterLabel.bottomAnchor, constant: 10),
                        ])
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var desireRow = -1
        if selectedArticleName == .chineseConceptionCalendar {
            desireRow = 2
        }else{
            desireRow = 3
        }
        if indexPath == IndexPath(row: desireRow, section: 1) {
            return 200
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            let headerView = UIView()
            headerView.backgroundColor = .clear
            headerView.translatesAutoresizingMaskIntoConstraints = false
            
            
            let gradientImageView = UIImageView()
            gradientImageView.layer.cornerRadius = 20
            gradientImageView.image = UIImage(named: "learningResourceBackground")
            gradientImageView.contentMode = .scaleAspectFill
            gradientImageView.clipsToBounds = true
            gradientImageView.translatesAutoresizingMaskIntoConstraints = false
            gradientImageView.hero.id = "gredientImageHeroID\(selectedCellItemIndex ?? 0)"
            
            headerView.addSubview(gradientImageView)
            
            NSLayoutConstraint.activate([
                gradientImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
                gradientImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                gradientImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                gradientImageView.widthAnchor.constraint(equalToConstant: tableView.widthOfView),
                gradientImageView.heightAnchor.constraint(equalToConstant: tableView.widthOfView * 0.5),
            ])
            
            let articleImageView = UIImageView()
            articleImageView.image = UIImage(named: selectedArticleImageName ?? "ohBabyArticleImg")
            articleImageView.contentMode = .scaleAspectFill
            articleImageView.clipsToBounds = true
            articleImageView.translatesAutoresizingMaskIntoConstraints = false
            articleImageView.hero.id = "resourceImageHeroID\(selectedCellItemIndex ?? 0)"
            
            headerView.addSubview(articleImageView)
            
            NSLayoutConstraint.activate([
                articleImageView.centerXAnchor.constraint(equalTo: gradientImageView.centerXAnchor),
                articleImageView.centerYAnchor.constraint(equalTo: gradientImageView.centerYAnchor),
                articleImageView.widthAnchor.constraint(equalToConstant: tableView.widthOfView * 0.4),
                articleImageView.heightAnchor.constraint(equalToConstant: tableView.widthOfView * 0.4),
            ])
            
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return (tableView.widthOfView * 0.5)
        } else {
            return 0
        }
    }
}
