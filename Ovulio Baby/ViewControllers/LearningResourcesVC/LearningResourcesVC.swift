//
//  LearningResourcesVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-11.
//

import UIKit

class LearningResourcesVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    
    var articleList = [
        //["title": "LearningResourcesVC.articles.ohBaby.headline"~, "image": "ohBabyArticleImg"],
        //["title": "LearningResourcesVC.articles.theRoadBeforeTheBump.headline"~, "image": "theRoadBeforeTheBumpArticleImg"],
        ["title": "LearningResourcesVC.articles.chineseConceptionCalendar.headline"~, "image": "chineseConceptionCalendarArticleImg"],
        ["title": "LearningResourcesVC.articles.positionPerfect.headline"~, "image": "positionPerfectArticleImg"],
        ["title": "LearningResourcesVC.articles.babyliciousNutritious.headline"~, "image": "babyliciousNutritiousArticleImg"],
        ["title": "LearningResourcesVC.articles.fertilityCalendar.headline"~, "image": "fertilityCalendarArticleImg"],
        ["title": "LearningResourcesVC.articles.waysToShowYour.headline"~, "image": "waysToShowYourArticleImg"],
        ["title": "LearningResourcesVC.articles.hitTheGym.headline"~, "image": "hitTheGymArticleImg"],
        //["title": "LearningResourcesVC.articles.howToSupportYourPartner.headline"~, "image": "howToSupportYourPartnerArticleImg"],
        //["title": "LearningResourcesVC.articles.ohBabySexAfterChildbirth.headline"~, "image": "ohBabySexAfterChildbirthArticleImg"],
    ]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = DeviceSize.isiPadDevice ? 15 : 7.5
        layout.minimumLineSpacing = DeviceSize.isiPadDevice ? 20 : 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(LearningResourceCell.self, forCellWithReuseIdentifier: "LearningResourceCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setUpBackground()
        setUpNavigationBar()
        setUpCollectionView()
    }
    
    
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            titleString: "LearningResourcesVC.headlineLabel.text"~
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
    
    func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        if let customNavBarView = customNavBarView {
            collectionView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        }else{
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.isiPadDevice ? 30 : 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DeviceSize.isiPadDevice ? -30 : -15),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension LearningResourcesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearningResourceCell", for: indexPath) as! LearningResourceCell
        cell.backgroundColor = .clear
        cell.cellGradientImageView.hero.id = "gredientImageHeroID\(indexPath.row)"
        cell.resourceImageView.hero.id = "resourceImageHeroID\(indexPath.row)"
        cell.setupContent(title: articleList[indexPath.row]["title"] ?? "Not Found", image: articleList[indexPath.row]["image"] ?? "ohBabyArticleImg")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.widthOfView
        if DeviceSize.isiPadDevice {
            width = collectionView.widthOfView * 0.988
        }
        return CGSize(width: (width / 2) - 5, height: (width / 2) + (DeviceSize.isiPadDevice ? -(width / 7) : (width / 8)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.showAnimation({
//            cell?.contentView.hero.id = "articleImageHeroID"
            let vc = LearningResourceArticleVC()
            vc.hero.isEnabled = true
            vc.selectedArticleName = ArticleName.allCases[indexPath.row]
            vc.selectedArticleImageName = self.articleList[indexPath.row]["image"]
            vc.selectedCellItemIndex = indexPath.row
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        })
    }
}
