//
//  SalesVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-28.
//

import UIKit
import SwiftyStoreKit
import SPAlert
import SPConfetti
import TrueTime
import FirebaseFirestore
import AppsFlyerLib
import StoreKit
import Device


class PlansModel: Codable {
    
    var headline: String
    var duration: String
    var durationDetails: String
    var beforePrice: String
    var price: String
    var priceDetails: String
    var priceLocale: Locale
    var discount: String
    var isSelected: Bool
    var dollarPrice: String
    var subscriptionType: String  // weekly, monthly, 3months
    
    init(headline: String, duration: String, durationDetails: String, beforePrice: String, price: String, priceDetails: String, discount: String, priceLocale: Locale, isSelected: Bool, dollarPrice: String, subscriptionType: String) {
        self.headline = headline
        self.duration = duration
        self.durationDetails = durationDetails
        self.beforePrice = beforePrice
        self.price = price
        self.priceDetails = priceDetails
        self.priceLocale = priceLocale
        self.discount = discount
        self.isSelected = isSelected
        self.dollarPrice = dollarPrice
        self.subscriptionType = subscriptionType
    }
}

class SalesReviewModel: Codable{
    var reviewText: String
    var userName: String
    
    init(reviewText: String, userName: String) {
        self.reviewText = reviewText
        self.userName = userName
    }
}

class SalesVC: UIViewController {
    
    // Define this in Class:
    // True Time
    let client = TrueTimeClient.sharedInstance
    private let leftButton = UIButton(type: .custom)
    var isFromAppStart = false
    var customNavBarView: CustomNavigationBar?
    var planCollectionHeight: CGFloat = DeviceSize.isiPadDevice ? 269 : 231.0
    let plansCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SalesPlanCell.self, forCellWithReuseIdentifier: "SalesPlanCell")
        return collectionView
    }()
    
    let plansCollectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SalesPlanCell.self, forCellWithReuseIdentifier: "SalesPlanCell")
        return collectionView
    }()
    
    let lifeTimePlanViewHeight: CGFloat = 110
    let lifeTimePlanView = UIView()
    let lifeTimePlanView2 = UIView()

    var lifeTimePlanDetail = PlansModel(headline: "SalesVC.plans.lifetime.typeTitle.headline.text"~, duration: "SalesVC.plans.lifetime.headline.text"~, durationDetails: "$49.99 \("SalesVC.plans.lifetime.details.text"~)", beforePrice: "0", price: "0.99", priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.lifetime.discount.headline.text"~, priceLocale: Locale(identifier: "en_US"), isSelected: false, dollarPrice: "$49.99", subscriptionType: "lifetime")
    var isProductAtZeroDollar: Bool = false
    var productAtZeroDollar: PurchaseOptions = .monthly
    var delegateShowReviewScreenProtocol: ShowReviewScreenProtocol?

    let reviewCollectionHeight: CGFloat = DeviceSize.isiPadDevice ? 269 : 220
    let reviewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: DeviceSize.isiPadDevice ? 35 : 15, bottom: 0, right: DeviceSize.isiPadDevice ? 35 : 15)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SalesReviewCell.self, forCellWithReuseIdentifier: "SalesReviewCell")
        return collectionView
    }()
    
    let futureParentsImageHeight = DeviceSize.isiPadDevice ? (ScreenSize.width * 0.85) / 2 : 210.0
    var ContinueButton: PurchaseButtonViewSmaller = {  // UIButton
        let button = PurchaseButtonViewSmaller()  // UIButton
        //button.setTitle("SalesVC.button.Continue.text"~, for: .normal)
        //button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.titleLabel.text = "InAppPurchaseOfferMenu.purchaseButton.titleLabel.text"~
        button.titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        button.backgroundColor = buttonAppLightColor
        button.layer.cornerRadius = 15
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let continueButtonGradientImageView = CommonView.getCommonImageView(image: "Gradient View IAP Menu Purchase Button")
    var plansArray = [
        PlansModel(headline: "", duration: "SalesVC.plans.1week.headline.text"~, durationDetails: "SalesVC.plans.1week.details.text"~, beforePrice: "0", price: " ", priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "", priceLocale: Locale(identifier: "en_US"), isSelected: false, dollarPrice: "", subscriptionType: "weekly"),
        PlansModel(headline: "SalesVC.plans.3Months.typeTitle.headline.text"~, duration: "SalesVC.plans.3Months.headline.text"~, durationDetails: "SalesVC.plans.3Months.details.text"~, beforePrice: " ", price: " ", priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.3Months.discount.headline.text"~, priceLocale: Locale(identifier: "en_US"), isSelected: true, dollarPrice: "", subscriptionType: "3months"),
        PlansModel(headline: "SalesVC.plans.1Month.typeTitle.headline.text"~, duration: "SalesVC.plans.1Month.headline.text"~, durationDetails: "SalesVC.plans.1Month.details.text"~, beforePrice: " ", price: " ", priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.1Month.discount.headline.text"~, priceLocale: Locale(identifier: "en_US"), isSelected: false, dollarPrice: "", subscriptionType: "monthly")
    ]
    var salesReviewArray = [
        SalesReviewModel(reviewText: "SalesVC.details.reviews.userName1.comment.text"~, userName: "SalesVC.details.reviews.userName1.text"~),
        SalesReviewModel(reviewText: "SalesVC.details.reviews.userName2.comment.text"~, userName: "SalesVC.details.reviews.userName2.text"~),
        SalesReviewModel(reviewText: "SalesVC.details.reviews.userName3.comment.text"~, userName: "SalesVC.details.reviews.userName3.text"~),
        SalesReviewModel(reviewText: "SalesVC.details.reviews.userName4.comment.text"~, userName: "SalesVC.details.reviews.userName4.text"~),
        SalesReviewModel(reviewText: "SalesVC.details.reviews.userName5.comment.text"~, userName: "SalesVC.details.reviews.userName5.text"~),
        SalesReviewModel(reviewText: "SalesVC.details.reviews.userName6.comment.text"~, userName: "SalesVC.details.reviews.userName6.text"~)]
    var selectedSubscriptionPlan: PurchaseOptions? = .lifetime
    let db = Firestore.firestore()
    var confettiView: SPConfettiView!
    var didPurchaseSuccessfully: (() -> Void)?
    
    
    var purchaseButtonTitle: String = ""
    var purchasePrice: Double = 0.0
    
    var inAppPurchasePrice: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Count how many times the IAP Menu needs to be shown until user purchases
        var countIapMenuOpen: Int = 0
        
        // User Defaults
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "countIapMenuOpen") != nil {
            countIapMenuOpen = userDefaults.value(forKey: "countIapMenuOpen") as! Int
        }
        countIapMenuOpen += 1
        userDefaults.setValue(countIapMenuOpen, forKey: "countIapMenuOpen")
        print("countIapMenuOpen \(countIapMenuOpen)")
        
        
//        plansArray.append()
//        plansArray.append()
//        plansArray.append()
        
        self.view.setUpBackground()
        if plansArray.count != 0 {
            //getIapInfo()
        }
        
        
        
        setUpUI()
        setUpScrollViewContent()
        setUpNavigationBar()
        
        confettiView = SPConfettiView()
        confettiView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(confettiView)
        NSLayoutConstraint.activate([
            confettiView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            confettiView.topAnchor.constraint(equalTo: self.view.topAnchor),
            confettiView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            confettiView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        
        
        
        
        //self.getIapInfoLifetimePurchaseOnlyOption()
        //self.getIapInfoMonthlyPurchaseOnlyOption()
        
        let db = Firestore.firestore()
        let docRefActivationCodes = db.collection("tracking").document("AppAdviceCampaign")
        docRefActivationCodes.getDocument { (document, error) in
            
            if let document = document, document.exists {
                
                if let shouldShowMonthlyPrice = document.data()!["shouldShowMonthlyPrice"] as? Bool {
                    print("shouldShowMonthlyPrice \(shouldShowMonthlyPrice)")
                    
                    if shouldShowMonthlyPrice == true {
                        
                        self.selectedSubscriptionPlan = .monthly
                        self.getIapInfoMonthlyPurchaseOnlyOption()
                        
                    } else {
                        
                        self.getIapInfoLifetimePurchaseOnlyOption()
                        
                    }
                    
                } else {
                    
                    self.getIapInfoLifetimePurchaseOnlyOption()
                    
                }
                
            } else {
                
                self.getIapInfoLifetimePurchaseOnlyOption()
                
            }
            
        }
        
        
        self.ContinueButton.isHidden = false
        self.continueButtonGradientImageView.isHidden = false
        
    }
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
//            titleString: "SalesVC.headlineLabel.text"~
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
        leftButton.isHidden = true
        leftButton.setImage(UIImage(named: "backButtonImg"), for: .normal)
        self.customNavBarView!.addSubview(leftButton)
        // Button Animation
        leftButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        leftButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: self.customNavBarView!.leadingAnchor, constant: 10),
            leftButton.centerYAnchor.constraint(equalTo: self.customNavBarView!.centerYAnchor),
            leftButton.widthAnchor.constraint(equalToConstant: 44),
            leftButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /*
        // For Test purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.inAppPurchaseSuccess(purchaseType: .lifetime)
        }
        */
        
        if self.leftButton.isHidden == true {
            
            self.delay(2.2) {
                
                self.leftButton.alpha = 0.0
                self.leftButton.isHidden = false
                
                UIView.animate(withDuration: 0.4, delay: 0.0) {
                    self.leftButton.alpha = 1.0
                }
                
            }
            
        }
        
        self.delay(1.0) {
            
            self.startPulsingPurchaseButton()
            
        }
        
    }
    
    func startPulsingPurchaseButton() {
        
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

        self.ContinueButton.layer.add(pulseGroup, forKey: "pulse")
        
    }
    
    @objc private func leftButtonAction() {
        
        leftButton.showAnimation {
            if self.isFromAppStart {
                let vc = HomeViewController()
                vc.needToShowSalesScreen = false
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
                return
            }
            self.dismiss(animated: true)
        }
        
    }
    
    func setUpUI() {
        
        let headlineLabel = CommonView.getCommonLabel(text: "SalesVC.details.headlineLabel.GetUnlimitedAccess.text"~, font: .boldSystemFont(ofSize: 24.pulse2Font()), lines: 0, alignment: .center)
        self.view.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25 + 20),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        let originalString = "SalesVC.details.headlineLabel.GetUnlimitedAccess.text"~
        let attributedString = NSMutableAttributedString(string: originalString)
        if let range = originalString.range(of: "SalesVC.details.headlineLabel.GetUnlimitedAccess.ColoredString.text"~) {
            let nsRange = NSRange(range, in: originalString)
            attributedString.addAttribute(.foregroundColor, value: girlAppColor, range: nsRange)
        }
        headlineLabel.attributedText = attributedString
        
        let backImage = CommonView.getCommonImageView(image: "salesPageIMG")
        backImage.contentMode = .scaleAspectFit
        self.view.addSubview(backImage)
        NSLayoutConstraint.activate([
            backImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            backImage.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 30),
            backImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            backImage.heightAnchor.constraint(equalToConstant: ScreenSize.height * 0.45)
        ])
        
    }
    
    func setUpScrollViewContent() {
        
        let scrollview = UIScrollView()
        scrollview.bounces = false
        scrollview.showsVerticalScrollIndicator = false
        let topHeight = (self.view.safeAreaInsets.top + 20 + 115 + (ScreenSize.height * (self.plansArray.count == 0 ? 0.33 : 0.40)))
        scrollview.contentInset = .init(top: topHeight, left: 0, bottom: -50, right: 0)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollview)
        scrollview.clipsToBounds = true
        NSLayoutConstraint.activate([
            scrollview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollview.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        let scrollContentView = UIView()
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.cornerRadius = 20
        scrollContentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        scrollContentView.backgroundColor = UIColor(hexString: "FFFBFB") ?? .white
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollview.addSubview(scrollContentView)
        NSLayoutConstraint.activate([
            scrollContentView.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            scrollContentView.topAnchor.constraint(equalTo: scrollview.topAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            scrollContentView.heightAnchor.constraint(equalToConstant: 900 + (planCollectionHeight * 2) + (lifeTimePlanViewHeight * 2) + reviewCollectionHeight + (futureParentsImageHeight * 2))  // 1938
        ])
        /*
        let headlineLabel = CommonView.getCommonLabel(text: "\("SalesVC.YourBabyWishGenderIs.headline.text"~) \(ProfileDataManager.shared.selectedGender == .boy ? "\("SalesVC.YourBabyWishGenderIs.AMaleBaby.headline.text"~)" : (ProfileDataManager.shared.selectedGender == .girl ? "\("SalesVC.YourBabyWishGenderIs.AGirlBaby.headline.text"~)" : "\("SalesVC.YourBabyWishGenderIs.DoesntMatter.headline.text"~)"))", font: .boldSystemFont(ofSize: 20.pulse2Font()), lines: 0, alignment: .center)
        scrollContentView.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.2) : 20),
            headlineLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            headlineLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -20)
        ])
        let headlineLabelOriginalString = headlineLabel.text ?? ""
        let headlineLabelAttributedString = NSMutableAttributedString(string: headlineLabelOriginalString)
        if let range = headlineLabelOriginalString.range(of: "SalesVC.YourBabyWishGenderIs.AMaleBaby.coloredString.headline.text"~) {
            let nsRange = NSRange(range, in: headlineLabelOriginalString)
            headlineLabelAttributedString.addAttribute(.foregroundColor, value: lightAppColor, range: nsRange)
        }
        if let range = headlineLabelOriginalString.range(of: "SalesVC.YourBabyWishGenderIs.AGirlBaby.coloredString.headline.text"~) {
            let nsRange = NSRange(range, in: headlineLabelOriginalString)
            headlineLabelAttributedString.addAttribute(.foregroundColor, value: girlAppColor, range: nsRange)
        }
        headlineLabel.attributedText = headlineLabelAttributedString
        
        let plansContainer = UIView()
        plansContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(plansContainer)
        NSLayoutConstraint.activate([
            plansContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.2) : 20),
            plansContainer.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 15),
            plansContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -20),
            plansContainer.heightAnchor.constraint(equalToConstant: planCollectionHeight)
        ])
        
        plansCollectionView.translatesAutoresizingMaskIntoConstraints = false
        plansContainer.addSubview(plansCollectionView)
        NSLayoutConstraint.activate([
            plansCollectionView.leadingAnchor.constraint(equalTo: plansContainer.leadingAnchor),
            plansCollectionView.trailingAnchor.constraint(equalTo: plansContainer.trailingAnchor),
            plansCollectionView.topAnchor.constraint(equalTo: plansContainer.topAnchor),
            plansCollectionView.bottomAnchor.constraint(equalTo: plansContainer.bottomAnchor),
        ])
        plansCollectionView.delegate = self
        plansCollectionView.dataSource = self
        
        
        scrollContentView.addSubview(lifeTimePlanView)
        setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView)
        lifeTimePlanView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lifeTimePlanView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.2) : 20),
            lifeTimePlanView.topAnchor.constraint(equalTo: plansCollectionView.bottomAnchor, constant: 15),
            lifeTimePlanView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -20),
            lifeTimePlanView.heightAnchor.constraint(equalToConstant: lifeTimePlanViewHeight)
        ])
        */
        
        let UnlockFeaturesLabel = CommonView.getCommonLabel(text: "SalesVC.details.headlineLabel.Unlock all features.text"~, font: .boldSystemFont(ofSize: 24.pulse2Font()), lines: 0, alignment: .center)
        scrollContentView.addSubview(UnlockFeaturesLabel)
        NSLayoutConstraint.activate([
            UnlockFeaturesLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            //UnlockFeaturesLabel.topAnchor.constraint(equalTo: lifeTimePlanView.bottomAnchor, constant: 30),
            UnlockFeaturesLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            UnlockFeaturesLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
        ])
        let originalString = "SalesVC.details.headlineLabel.Unlock all features.text"~
        let attributedString = NSMutableAttributedString(string: originalString)
        if let range = originalString.range(of: "SalesVC.details.headlineLabel.Unlock all features.ColoredString.text"~) {
            let nsRange = NSRange(range, in: originalString)
            attributedString.addAttribute(.foregroundColor, value: girlAppColor, range: nsRange)
        }
        UnlockFeaturesLabel.attributedText = attributedString
        
        let unlockFeatureContainer = UIView()
        scrollContentView.addSubview(unlockFeatureContainer)
        unlockFeatureContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unlockFeatureContainer.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            unlockFeatureContainer.topAnchor.constraint(equalTo: UnlockFeaturesLabel.bottomAnchor, constant: 30),
            unlockFeatureContainer.widthAnchor.constraint(equalToConstant: 280),
            unlockFeatureContainer.heightAnchor.constraint(equalToConstant: 55 * 4)
        ])
        let featureContainer1 = UIView()
        unlockFeatureContainer.addSubview(featureContainer1)
        featureContainer1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            featureContainer1.leadingAnchor.constraint(equalTo: unlockFeatureContainer.leadingAnchor),
            featureContainer1.topAnchor.constraint(equalTo: unlockFeatureContainer.topAnchor),
            featureContainer1.trailingAnchor.constraint(equalTo: unlockFeatureContainer.trailingAnchor),
            featureContainer1.heightAnchor.constraint(equalToConstant: 55)
        ])
        let salesFeature1IMG = CommonView.getCommonImageView(image: "salesFeature1IMG")
        featureContainer1.addSubview(salesFeature1IMG)
        NSLayoutConstraint.activate([
            salesFeature1IMG.leadingAnchor.constraint(equalTo: featureContainer1.leadingAnchor),
            salesFeature1IMG.topAnchor.constraint(equalTo: featureContainer1.topAnchor),
            salesFeature1IMG.heightAnchor.constraint(equalToConstant: 45),
            salesFeature1IMG.widthAnchor.constraint(equalToConstant: 45)
        ])
        let salesFeature1Label = CommonView.getCommonLabel(text: "SalesVC.details.Unlock all features.Monthly gender Predictions.text"~)
        salesFeature1Label.adjustsFontSizeToFitWidth = true
        salesFeature1Label.minimumScaleFactor = 0.2
        featureContainer1.addSubview(salesFeature1Label)
        NSLayoutConstraint.activate([
            salesFeature1Label.centerYAnchor.constraint(equalTo: salesFeature1IMG.centerYAnchor),
            salesFeature1Label.leadingAnchor.constraint(equalTo: salesFeature1IMG.trailingAnchor, constant: 15),
            salesFeature1Label.trailingAnchor.constraint(equalTo: featureContainer1.trailingAnchor),
        ])
        
        let featureContainer2 = UIView()
        unlockFeatureContainer.addSubview(featureContainer2)
        featureContainer2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            featureContainer2.leadingAnchor.constraint(equalTo: unlockFeatureContainer.leadingAnchor),
            featureContainer2.topAnchor.constraint(equalTo: featureContainer1.bottomAnchor, constant: 3),
            featureContainer2.trailingAnchor.constraint(equalTo: unlockFeatureContainer.trailingAnchor),
            featureContainer2.heightAnchor.constraint(equalToConstant: 55)
        ])
        let salesFeature2IMG = CommonView.getCommonImageView(image: "salesFeature2IMG")
        featureContainer2.addSubview(salesFeature2IMG)
        NSLayoutConstraint.activate([
            salesFeature2IMG.leadingAnchor.constraint(equalTo: featureContainer2.leadingAnchor),
            salesFeature2IMG.topAnchor.constraint(equalTo: featureContainer2.topAnchor),
            salesFeature2IMG.heightAnchor.constraint(equalToConstant: 45),
            salesFeature2IMG.widthAnchor.constraint(equalToConstant: 45)
        ])
        let salesFeature2Label = CommonView.getCommonLabel(text: "SalesVC.details.Unlock all features.Unlimited Ovulation Insights.text"~)
        salesFeature2Label.adjustsFontSizeToFitWidth = true
        salesFeature2Label.minimumScaleFactor = 0.2
        featureContainer2.addSubview(salesFeature2Label)
        NSLayoutConstraint.activate([
            salesFeature2Label.centerYAnchor.constraint(equalTo: salesFeature2IMG.centerYAnchor),
            salesFeature2Label.leadingAnchor.constraint(equalTo: salesFeature2IMG.trailingAnchor, constant: 15),
            salesFeature2Label.trailingAnchor.constraint(equalTo: featureContainer2.trailingAnchor),
        ])
        
        let featureContainer3 = UIView()
        unlockFeatureContainer.addSubview(featureContainer3)
        featureContainer3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            featureContainer3.leadingAnchor.constraint(equalTo: unlockFeatureContainer.leadingAnchor),
            featureContainer3.topAnchor.constraint(equalTo: featureContainer2.bottomAnchor, constant: 3),
            featureContainer3.trailingAnchor.constraint(equalTo: unlockFeatureContainer.trailingAnchor),
            featureContainer3.heightAnchor.constraint(equalToConstant: 55)
        ])
        let salesFeature3IMG = CommonView.getCommonImageView(image: "salesFeature3IMG")
        featureContainer3.addSubview(salesFeature3IMG)
        NSLayoutConstraint.activate([
            salesFeature3IMG.leadingAnchor.constraint(equalTo: featureContainer3.leadingAnchor),
            salesFeature3IMG.topAnchor.constraint(equalTo: featureContainer3.topAnchor),
            salesFeature3IMG.heightAnchor.constraint(equalToConstant: 45),
            salesFeature3IMG.widthAnchor.constraint(equalToConstant: 45)
        ])
        let salesFeature3Label = CommonView.getCommonLabel(text: "SalesVC.details.Unlock all features.Gender Influencing Sex Practices.text"~)
        salesFeature3Label.adjustsFontSizeToFitWidth = true
        salesFeature3Label.minimumScaleFactor = 0.2
        featureContainer3.addSubview(salesFeature3Label)
        NSLayoutConstraint.activate([
            salesFeature3Label.centerYAnchor.constraint(equalTo: salesFeature3IMG.centerYAnchor),
            salesFeature3Label.leadingAnchor.constraint(equalTo: salesFeature3IMG.trailingAnchor, constant: 15),
            salesFeature3Label.trailingAnchor.constraint(equalTo: featureContainer3.trailingAnchor),
        ])
        
        let featureContainer4 = UIView()
        unlockFeatureContainer.addSubview(featureContainer4)
        featureContainer4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            featureContainer4.leadingAnchor.constraint(equalTo: unlockFeatureContainer.leadingAnchor),
            featureContainer4.topAnchor.constraint(equalTo: featureContainer3.bottomAnchor, constant: 3),
            featureContainer4.trailingAnchor.constraint(equalTo: unlockFeatureContainer.trailingAnchor),
            featureContainer4.heightAnchor.constraint(equalToConstant: 55)
        ])
        let salesFeature4IMG = CommonView.getCommonImageView(image: "salesFeature4IMG")
        featureContainer4.addSubview(salesFeature4IMG)
        NSLayoutConstraint.activate([
            salesFeature4IMG.leadingAnchor.constraint(equalTo: featureContainer4.leadingAnchor),
            salesFeature4IMG.topAnchor.constraint(equalTo: featureContainer4.topAnchor),
            salesFeature4IMG.heightAnchor.constraint(equalToConstant: 45),
            salesFeature4IMG.widthAnchor.constraint(equalToConstant: 45)
        ])
        let salesFeature4Label = CommonView.getCommonLabel(text: "SalesVC.details.Unlock all features.Access to Expert written Articles.text"~)
        salesFeature4Label.adjustsFontSizeToFitWidth = true
        salesFeature4Label.minimumScaleFactor = 0.2
        featureContainer4.addSubview(salesFeature4Label)
        NSLayoutConstraint.activate([
            salesFeature4Label.centerYAnchor.constraint(equalTo: salesFeature4IMG.centerYAnchor),
            salesFeature4Label.leadingAnchor.constraint(equalTo: salesFeature4IMG.trailingAnchor, constant: 15),
            salesFeature4Label.trailingAnchor.constraint(equalTo: featureContainer4.trailingAnchor),
        ])
        
        let futureParentsHeadlineLabel = CommonView.getCommonLabel(text: "SalesVC.details.headlineLabel.Future parents can’t stop raving.text"~, font: .boldSystemFont(ofSize: 24.pulse2Font()), lines: 0, alignment: .center)
        scrollContentView.addSubview(futureParentsHeadlineLabel)
        NSLayoutConstraint.activate([
            futureParentsHeadlineLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.2) : 20),
            futureParentsHeadlineLabel.topAnchor.constraint(equalTo: unlockFeatureContainer.bottomAnchor, constant: 40),
            futureParentsHeadlineLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -20),
        ])
        let futureParentsString = "SalesVC.details.headlineLabel.Future parents can’t stop raving.text"~
        let futureParentsStringattributedString = NSMutableAttributedString(string: futureParentsString)
        if let range = futureParentsString.range(of: "SalesVC.details.headlineLabel.Future parents can’t stop raving.ColoredString.text"~) {
            let nsRange = NSRange(range, in: futureParentsString)
            futureParentsStringattributedString.addAttribute(.foregroundColor, value: girlAppColor, range: nsRange)
        }
        futureParentsHeadlineLabel.attributedText = futureParentsStringattributedString
        
        let futureParentsImageContainer = UIView()
        futureParentsImageContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(futureParentsImageContainer)
        NSLayoutConstraint.activate([
            futureParentsImageContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.15) : 15),
            futureParentsImageContainer.topAnchor.constraint(equalTo: futureParentsHeadlineLabel.bottomAnchor, constant: 15),
            futureParentsImageContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.15) : -15),
            futureParentsImageContainer.heightAnchor.constraint(equalToConstant: (futureParentsImageHeight * 2) + 10)
        ])
        
        let futureParentsIMG00 = CommonView.getCommonImageView(image: "futureParentsIMG00")
        futureParentsIMG00.contentMode = .scaleAspectFill
        futureParentsIMG00.clipsToBounds = true
        futureParentsIMG00.layer.cornerRadius = 20
        futureParentsImageContainer.addSubview(futureParentsIMG00)
        NSLayoutConstraint.activate([
            futureParentsIMG00.leadingAnchor.constraint(equalTo: futureParentsImageContainer.leadingAnchor),
            futureParentsIMG00.topAnchor.constraint(equalTo: futureParentsImageContainer.topAnchor),
            futureParentsIMG00.widthAnchor.constraint(equalTo: futureParentsImageContainer.widthAnchor, multiplier: 0.49),
            futureParentsIMG00.heightAnchor.constraint(equalToConstant: futureParentsImageHeight)
        ])
        
        let futureParentsIMG01 = CommonView.getCommonImageView(image: "futureParentsIMG01")
        futureParentsIMG01.contentMode = .scaleAspectFill
        futureParentsIMG01.clipsToBounds = true
        futureParentsIMG01.layer.cornerRadius = 20
        futureParentsImageContainer.addSubview(futureParentsIMG01)
        NSLayoutConstraint.activate([
            futureParentsIMG01.trailingAnchor.constraint(equalTo: futureParentsImageContainer.trailingAnchor),
            futureParentsIMG01.topAnchor.constraint(equalTo: futureParentsImageContainer.topAnchor),
            futureParentsIMG01.widthAnchor.constraint(equalTo: futureParentsImageContainer.widthAnchor, multiplier: 0.49),
            futureParentsIMG01.heightAnchor.constraint(equalToConstant: futureParentsImageHeight)
        ])
        
        let futureParentsIMG10 = CommonView.getCommonImageView(image: "futureParentsIMG10")
        futureParentsIMG10.clipsToBounds = true
        futureParentsIMG10.layer.cornerRadius = 20
        futureParentsIMG10.contentMode = .scaleAspectFill
        futureParentsImageContainer.addSubview(futureParentsIMG10)
        NSLayoutConstraint.activate([
            futureParentsIMG10.leadingAnchor.constraint(equalTo: futureParentsImageContainer.leadingAnchor),
            futureParentsIMG10.topAnchor.constraint(equalTo: futureParentsIMG00.bottomAnchor, constant: 10),
            futureParentsIMG10.widthAnchor.constraint(equalTo: futureParentsImageContainer.widthAnchor, multiplier: 0.49),
            futureParentsIMG10.heightAnchor.constraint(equalToConstant: futureParentsImageHeight)
        ])
            
        let futureParentsIMG11 = CommonView.getCommonImageView(image: "futureParentsIMG11")
        futureParentsIMG11.clipsToBounds = true
        futureParentsIMG11.layer.cornerRadius = 20
        futureParentsIMG11.contentMode = .scaleAspectFill
        futureParentsImageContainer.addSubview(futureParentsIMG11)
        NSLayoutConstraint.activate([
            futureParentsIMG11.trailingAnchor.constraint(equalTo: futureParentsImageContainer.trailingAnchor),
            futureParentsIMG11.topAnchor.constraint(equalTo: futureParentsIMG00.bottomAnchor, constant: 10),
            futureParentsIMG11.widthAnchor.constraint(equalTo: futureParentsImageContainer.widthAnchor, multiplier: 0.49),
            futureParentsIMG11.heightAnchor.constraint(equalToConstant: futureParentsImageHeight)
        ])
        
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        scrollContentView.addSubview(reviewCollectionView)
        NSLayoutConstraint.activate([
            reviewCollectionView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            reviewCollectionView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            reviewCollectionView.topAnchor.constraint(equalTo: futureParentsImageContainer.bottomAnchor, constant: 15),
            reviewCollectionView.heightAnchor.constraint(equalToConstant: reviewCollectionHeight),
        ])
        
        let futureParentsCheckListItemHeight = 20.0
        let futureParentsCheckListContainer = UIView()
        scrollContentView.addSubview(futureParentsCheckListContainer)
        futureParentsCheckListContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            futureParentsCheckListContainer.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            futureParentsCheckListContainer.topAnchor.constraint(equalTo: reviewCollectionView.bottomAnchor, constant: 30),
            futureParentsCheckListContainer.widthAnchor.constraint(equalToConstant: 280),
            futureParentsCheckListContainer.heightAnchor.constraint(equalToConstant: CGFloat((futureParentsCheckListItemHeight + 10) * 4))
        ])
        let futureParentsCheckListItem1 = UIView()
        futureParentsCheckListContainer.addSubview(futureParentsCheckListItem1)
        futureParentsCheckListItem1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            futureParentsCheckListItem1.leadingAnchor.constraint(equalTo: futureParentsCheckListContainer.leadingAnchor),
            futureParentsCheckListItem1.topAnchor.constraint(equalTo: futureParentsCheckListContainer.topAnchor),
            futureParentsCheckListItem1.trailingAnchor.constraint(equalTo: futureParentsCheckListContainer.trailingAnchor),
            futureParentsCheckListItem1.heightAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight + 10)
        ])
        let futureParentsCheckListSalesFeature1IMG = CommonView.getCommonImageView(image: "futureParentsCheckListSalesFeatureIMG")
        futureParentsCheckListSalesFeature1IMG.contentMode = .scaleAspectFill
        futureParentsCheckListItem1.addSubview(futureParentsCheckListSalesFeature1IMG)
        NSLayoutConstraint.activate([
            futureParentsCheckListSalesFeature1IMG.leadingAnchor.constraint(equalTo: futureParentsCheckListItem1.leadingAnchor),
            futureParentsCheckListSalesFeature1IMG.topAnchor.constraint(equalTo: futureParentsCheckListItem1.topAnchor),
            futureParentsCheckListSalesFeature1IMG.heightAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight),
            futureParentsCheckListSalesFeature1IMG.widthAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight)
        ])
        let futureParentsCheckListSalesFeature1Label = CommonView.getCommonLabel(text: "SalesVC.details.Future parents can’t stop raving.Higher Chance of getting Pregnant.text"~)
        futureParentsCheckListSalesFeature1Label.adjustsFontSizeToFitWidth = true
        futureParentsCheckListSalesFeature1Label.minimumScaleFactor = 0.2
        futureParentsCheckListItem1.addSubview(futureParentsCheckListSalesFeature1Label)
        NSLayoutConstraint.activate([
            futureParentsCheckListSalesFeature1Label.centerYAnchor.constraint(equalTo: futureParentsCheckListSalesFeature1IMG.centerYAnchor),
            futureParentsCheckListSalesFeature1Label.leadingAnchor.constraint(equalTo: futureParentsCheckListSalesFeature1IMG.trailingAnchor, constant: 15),
            futureParentsCheckListSalesFeature1Label.trailingAnchor.constraint(equalTo: futureParentsCheckListItem1.trailingAnchor),
        ])
        
        let futureParentsCheckListItem2 = UIView()
        futureParentsCheckListContainer.addSubview(futureParentsCheckListItem2)
        futureParentsCheckListItem2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            futureParentsCheckListItem2.leadingAnchor.constraint(equalTo: futureParentsCheckListContainer.leadingAnchor),
            futureParentsCheckListItem2.topAnchor.constraint(equalTo: futureParentsCheckListItem1.bottomAnchor, constant: 3),
            futureParentsCheckListItem2.trailingAnchor.constraint(equalTo: futureParentsCheckListContainer.trailingAnchor),
            futureParentsCheckListItem2.heightAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight + 10)
        ])
        let futureParentsCheckListSalesFeature2IMG = CommonView.getCommonImageView(image: "futureParentsCheckListSalesFeatureIMG")
        futureParentsCheckListSalesFeature2IMG.contentMode = .scaleAspectFill
        futureParentsCheckListItem2.addSubview(futureParentsCheckListSalesFeature2IMG)
        NSLayoutConstraint.activate([
            futureParentsCheckListSalesFeature2IMG.leadingAnchor.constraint(equalTo: futureParentsCheckListItem2.leadingAnchor),
            futureParentsCheckListSalesFeature2IMG.topAnchor.constraint(equalTo: futureParentsCheckListItem2.topAnchor),
            futureParentsCheckListSalesFeature2IMG.heightAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight),
            futureParentsCheckListSalesFeature2IMG.widthAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight)
        ])
        let futureParentsCheckListSalesFeature2Label = CommonView.getCommonLabel(text: "SalesVC.details.Future parents can’t stop raving.Improved Intimacy routine.text"~)
        futureParentsCheckListSalesFeature2Label.adjustsFontSizeToFitWidth = true
        futureParentsCheckListSalesFeature2Label.minimumScaleFactor = 0.2
        futureParentsCheckListItem2.addSubview(futureParentsCheckListSalesFeature2Label)
        NSLayoutConstraint.activate([
            futureParentsCheckListSalesFeature2Label.centerYAnchor.constraint(equalTo: futureParentsCheckListSalesFeature2IMG.centerYAnchor),
            futureParentsCheckListSalesFeature2Label.leadingAnchor.constraint(equalTo: futureParentsCheckListSalesFeature2IMG.trailingAnchor, constant: 15),
            futureParentsCheckListSalesFeature2Label.trailingAnchor.constraint(equalTo: futureParentsCheckListItem2.trailingAnchor),
        ])
        
        let futureParentsCheckListItem3 = UIView()
        futureParentsCheckListContainer.addSubview(futureParentsCheckListItem3)
        futureParentsCheckListItem3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            futureParentsCheckListItem3.leadingAnchor.constraint(equalTo: futureParentsCheckListContainer.leadingAnchor),
            futureParentsCheckListItem3.topAnchor.constraint(equalTo: futureParentsCheckListItem2.bottomAnchor, constant: 3),
            futureParentsCheckListItem3.trailingAnchor.constraint(equalTo: futureParentsCheckListContainer.trailingAnchor),
            futureParentsCheckListItem3.heightAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight + 10)
        ])
        let futureParentsCheckListSalesFeature3IMG = CommonView.getCommonImageView(image: "futureParentsCheckListSalesFeatureIMG")
        futureParentsCheckListSalesFeature3IMG.contentMode = .scaleAspectFill
        futureParentsCheckListItem3.addSubview(futureParentsCheckListSalesFeature3IMG)
        NSLayoutConstraint.activate([
            futureParentsCheckListSalesFeature3IMG.leadingAnchor.constraint(equalTo: futureParentsCheckListItem3.leadingAnchor),
            futureParentsCheckListSalesFeature3IMG.topAnchor.constraint(equalTo: futureParentsCheckListItem3.topAnchor),
            futureParentsCheckListSalesFeature3IMG.heightAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight),
            futureParentsCheckListSalesFeature3IMG.widthAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight)
        ])
        let futureParentsCheckListSalesFeature3Label = CommonView.getCommonLabel(text: "SalesVC.details.Future parents can’t stop raving.Regular updates with new features.text"~)
        futureParentsCheckListSalesFeature3Label.adjustsFontSizeToFitWidth = true
        futureParentsCheckListSalesFeature3Label.minimumScaleFactor = 0.2
        futureParentsCheckListItem3.addSubview(futureParentsCheckListSalesFeature3Label)
        NSLayoutConstraint.activate([
            futureParentsCheckListSalesFeature3Label.centerYAnchor.constraint(equalTo: futureParentsCheckListSalesFeature3IMG.centerYAnchor),
            futureParentsCheckListSalesFeature3Label.leadingAnchor.constraint(equalTo: futureParentsCheckListSalesFeature3IMG.trailingAnchor, constant: 15),
            futureParentsCheckListSalesFeature3Label.trailingAnchor.constraint(equalTo: futureParentsCheckListItem3.trailingAnchor),
        ])
        
        let futureParentsCheckListItem4 = UIView()
        futureParentsCheckListContainer.addSubview(futureParentsCheckListItem4)
        futureParentsCheckListItem4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            futureParentsCheckListItem4.leadingAnchor.constraint(equalTo: futureParentsCheckListContainer.leadingAnchor),
            futureParentsCheckListItem4.topAnchor.constraint(equalTo: futureParentsCheckListItem3.bottomAnchor, constant: 3),
            futureParentsCheckListItem4.trailingAnchor.constraint(equalTo: futureParentsCheckListContainer.trailingAnchor),
            futureParentsCheckListItem4.heightAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight + 10)
        ])
        let futureParentsCheckListSalesFeature4IMG = CommonView.getCommonImageView(image: "futureParentsCheckListSalesFeatureIMG")
        futureParentsCheckListSalesFeature4IMG.contentMode = .scaleAspectFill
        futureParentsCheckListItem4.addSubview(futureParentsCheckListSalesFeature4IMG)
        NSLayoutConstraint.activate([
            futureParentsCheckListSalesFeature4IMG.leadingAnchor.constraint(equalTo: futureParentsCheckListItem4.leadingAnchor),
            futureParentsCheckListSalesFeature4IMG.topAnchor.constraint(equalTo: futureParentsCheckListItem4.topAnchor),
            futureParentsCheckListSalesFeature4IMG.heightAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight),
            futureParentsCheckListSalesFeature4IMG.widthAnchor.constraint(equalToConstant: futureParentsCheckListItemHeight)
        ])
        let futureParentsCheckListSalesFeature4Label = CommonView.getCommonLabel(text: "SalesVC.details.Future parents can’t stop raving.Anti-boring guarantee.text"~)
        futureParentsCheckListSalesFeature4Label.adjustsFontSizeToFitWidth = true
        futureParentsCheckListSalesFeature4Label.minimumScaleFactor = 0.2
        futureParentsCheckListItem4.addSubview(futureParentsCheckListSalesFeature4Label)
        NSLayoutConstraint.activate([
            futureParentsCheckListSalesFeature4Label.centerYAnchor.constraint(equalTo: futureParentsCheckListSalesFeature4IMG.centerYAnchor),
            futureParentsCheckListSalesFeature4Label.leadingAnchor.constraint(equalTo: futureParentsCheckListSalesFeature4IMG.trailingAnchor, constant: 15),
            futureParentsCheckListSalesFeature4Label.trailingAnchor.constraint(equalTo: futureParentsCheckListItem4.trailingAnchor),
        ])
        
        let developedWithHeadlineLabel = CommonView.getCommonLabel(text: "SalesVC.details.headlineLabel.Developed with\nexperts.text"~, font: .boldSystemFont(ofSize: 24.pulse2Font()), lines: 0, alignment: .center)
        scrollContentView.addSubview(developedWithHeadlineLabel)
        NSLayoutConstraint.activate([
            developedWithHeadlineLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            developedWithHeadlineLabel.topAnchor.constraint(equalTo: futureParentsCheckListContainer.bottomAnchor, constant: 40),
            developedWithHeadlineLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
        ])
        let developedWithString = "SalesVC.details.headlineLabel.Developed with\nexperts.text"~
        let developedWithStringattributedString = NSMutableAttributedString(string: developedWithString)
        if let range = developedWithString.range(of: "SalesVC.details.headlineLabel.Developed with\nexperts.ColoredString.text"~) {
            let nsRange = NSRange(range, in: developedWithString)
            developedWithStringattributedString.addAttribute(.foregroundColor, value: girlAppColor, range: nsRange)
        }
        developedWithHeadlineLabel.attributedText = developedWithStringattributedString
        
        let developedWithSubtitleLabel = CommonView.getCommonLabel(text: "SalesVC.details.Developed with\nexperts.subtitleHeadlineText.text"~, lines: 0, alignment: .center)
        developedWithSubtitleLabel.adjustsFontSizeToFitWidth = true
        developedWithSubtitleLabel.minimumScaleFactor = 0.2
        scrollContentView.addSubview(developedWithSubtitleLabel)
        NSLayoutConstraint.activate([
            developedWithSubtitleLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.2) : 30),
            developedWithSubtitleLabel.topAnchor
                .constraint(equalTo: developedWithHeadlineLabel.bottomAnchor, constant: 15),
            developedWithSubtitleLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -30),
        ])
        
        let containerView = UIView()
        scrollContentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: developedWithSubtitleLabel.bottomAnchor, constant: -50),
            containerView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 80.pulse(20))  // 510
        ])
        /* ALSO CHANGE 80 from above to 510 again
        // Create and add the child view controller.
        let childViewController = OurExpertsOptionPageVC()
        childViewController.isFromSalesPage = true
        addChild(childViewController)
        childViewController.view.frame = containerView.bounds
        containerView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        */
        
        
        
        /*
        let ChooseYourBabHeadlineLabel = CommonView.getCommonLabel(text: "SalesVC.details.headlineLabel.Choose your baby\nconception plan.text"~, font: .boldSystemFont(ofSize: 24), lines: 0, alignment: .center)
        scrollContentView.addSubview(ChooseYourBabHeadlineLabel)
        NSLayoutConstraint.activate([
            ChooseYourBabHeadlineLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            ChooseYourBabHeadlineLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: DeviceSize.isiPadDevice ? -25 : -15),
            ChooseYourBabHeadlineLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
        ])
        let ChooseYourBabString = "SalesVC.details.headlineLabel.Choose your baby\nconception plan.text"~
        let ChooseYourBabStringattributedString = NSMutableAttributedString(string: ChooseYourBabString)
        if let range = ChooseYourBabString.range(of: "SalesVC.details.headlineLabel.Choose your baby\nconception plan.coloredString.text"~) {
            let nsRange = NSRange(range, in: ChooseYourBabString)
            ChooseYourBabStringattributedString.addAttribute(.foregroundColor, value: girlAppColor, range: nsRange)
        }
        ChooseYourBabHeadlineLabel.attributedText = ChooseYourBabStringattributedString
        
        let plansContainer2 = UIView()
        plansContainer2.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(plansContainer2)
        NSLayoutConstraint.activate([
            plansContainer2.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.2) : 20),
            plansContainer2.topAnchor.constraint(equalTo: ChooseYourBabHeadlineLabel.bottomAnchor, constant: 20),
            plansContainer2.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -20),
            plansContainer2.heightAnchor.constraint(equalToConstant: planCollectionHeight)
        ])
        
        plansCollectionView2.translatesAutoresizingMaskIntoConstraints = false
        plansContainer2.addSubview(plansCollectionView2)
        NSLayoutConstraint.activate([
            plansCollectionView2.leadingAnchor.constraint(equalTo: plansContainer2.leadingAnchor),
            plansCollectionView2.trailingAnchor.constraint(equalTo: plansContainer2.trailingAnchor),
            plansCollectionView2.topAnchor.constraint(equalTo: plansContainer2.topAnchor),
            plansCollectionView2.bottomAnchor.constraint(equalTo: plansContainer2.bottomAnchor),
        ])
        plansCollectionView2.delegate = self
        plansCollectionView2.dataSource = self
        
        
        scrollContentView.addSubview(lifeTimePlanView2)
        setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView2)
        lifeTimePlanView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lifeTimePlanView2.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.2) : 20),
            lifeTimePlanView2.topAnchor.constraint(equalTo: plansCollectionView2.bottomAnchor, constant: 15),
            lifeTimePlanView2.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -20),
            lifeTimePlanView2.heightAnchor.constraint(equalToConstant: lifeTimePlanViewHeight)
        ])
        */
        
        let SubscriptionsWillBeLabel = CommonView.getCommonLabel(text: "SalesVC.details.Choose your baby\nconception plan.subtitleText.text"~ + "\n\n\n\n\n\n\n\n\n\n\n\n\n", textColor: UIColor(hexString: "AA97BD") ?? appColor, font: .systemFont(ofSize: 12), lines: 0, alignment: .center)
        SubscriptionsWillBeLabel.translatesAutoresizingMaskIntoConstraints = false
        SubscriptionsWillBeLabel.adjustsFontSizeToFitWidth = true
        SubscriptionsWillBeLabel.minimumScaleFactor = 0.2
        scrollContentView.addSubview(SubscriptionsWillBeLabel)
        NSLayoutConstraint.activate([
            SubscriptionsWillBeLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.2) : 15),
            //SubscriptionsWillBeLabel.topAnchor.constraint(equalTo: lifeTimePlanView2.bottomAnchor, constant: 15),
            SubscriptionsWillBeLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 15),
            SubscriptionsWillBeLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.2) : -15),
            SubscriptionsWillBeLabel.bottomAnchor.constraint(lessThanOrEqualTo: scrollContentView.bottomAnchor, constant: 50)
        ])
        
        
        self.continueButtonGradientImageView.isHidden = true
        view.addSubview(continueButtonGradientImageView)
        view.addSubview(ContinueButton)
        // Button Animation
        ContinueButton.buttonReaction.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        ContinueButton.buttonReaction.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        NSLayoutConstraint.activate([
            ContinueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            ContinueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ContinueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ContinueButton.heightAnchor.constraint(equalToConstant: 60),
//            ContinueButton.bottomAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        ContinueButton.buttonReaction.addTarget(self, action: #selector(purchaseButtonAction), for: .touchUpInside)
        ContinueButton.layer.shadowColor = appColor?.cgColor
        ContinueButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        ContinueButton.layer.shadowOpacity = 0.7
        ContinueButton.layer.shadowRadius = 8
        NSLayoutConstraint.activate([
            continueButtonGradientImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            continueButtonGradientImageView.topAnchor.constraint(equalTo: ContinueButton.topAnchor, constant: -22),
            continueButtonGradientImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            continueButtonGradientImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    func setupLifetimePlanView(lifeTimePlanView: UIView) {
        
        lifeTimePlanView.backgroundColor = UIColor(hexString: "AA97BD") ?? appColor
        lifeTimePlanView.layer.cornerRadius = 8
        
        lifeTimePlanView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        let lifeTimePlanViewHeadline = CommonView.getCommonLabel(text: lifeTimePlanDetail.headline, textColor: .white, font: .mymediumSystemFont(ofSize: 14))
        lifeTimePlanView.addSubview(lifeTimePlanViewHeadline)
        NSLayoutConstraint.activate([
            lifeTimePlanViewHeadline.centerXAnchor.constraint(equalTo: lifeTimePlanView.centerXAnchor),
            lifeTimePlanViewHeadline.topAnchor.constraint(equalTo: lifeTimePlanView.topAnchor, constant: 2)
        ])
        
        
        let lifeTimePlanInnerView = UIView()
        lifeTimePlanView.addSubview(lifeTimePlanInnerView)
        lifeTimePlanInnerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lifeTimePlanInnerView.leadingAnchor.constraint(equalTo: lifeTimePlanView.leadingAnchor, constant: 3),
            lifeTimePlanInnerView.topAnchor.constraint(equalTo: lifeTimePlanViewHeadline.bottomAnchor, constant: 2),
            lifeTimePlanInnerView.trailingAnchor.constraint(equalTo: lifeTimePlanView.trailingAnchor, constant: -3),
            lifeTimePlanInnerView.bottomAnchor.constraint(equalTo: lifeTimePlanView.bottomAnchor, constant: -3),
        ])
        lifeTimePlanInnerView.backgroundColor = .white
        lifeTimePlanInnerView.layer.cornerRadius = 8
        
        let detailHeadlineLabel = CommonView.getCommonLabel(text: lifeTimePlanDetail.duration, font: .mymediumSystemFont(ofSize: 18.pulse2Font()))
        lifeTimePlanInnerView.addSubview(detailHeadlineLabel)
        NSLayoutConstraint.activate([
            detailHeadlineLabel.leadingAnchor.constraint(equalTo: lifeTimePlanInnerView.leadingAnchor, constant: 15),
            detailHeadlineLabel.topAnchor.constraint(equalTo: lifeTimePlanInnerView.topAnchor, constant: 15),
        ])
        
        let discountLabel = CommonView.getCommonLabel(text: lifeTimePlanDetail.discount, textColor: UIColor(hexString: "F79E1A") ?? .yellow, font: .mymediumSystemFont(ofSize: 18.pulse2Font()))
        lifeTimePlanInnerView.addSubview(discountLabel)
        NSLayoutConstraint.activate([
            discountLabel.leadingAnchor.constraint(equalTo: detailHeadlineLabel.trailingAnchor, constant: 4),
            discountLabel.topAnchor.constraint(equalTo: detailHeadlineLabel.topAnchor),
        ])
        
        let totalPriceLabel = CommonView.getCommonLabel(text: lifeTimePlanDetail.durationDetails, textColor: UIColor(hexString: "AA97BD") ?? appColor, font: .systemFont(ofSize: 13.pulse2Font()), alignment: .left)
        lifeTimePlanInnerView.addSubview(totalPriceLabel)
        NSLayoutConstraint.activate([
            totalPriceLabel.leadingAnchor.constraint(equalTo: detailHeadlineLabel.leadingAnchor, constant: 0),
            totalPriceLabel.topAnchor.constraint(equalTo: detailHeadlineLabel.bottomAnchor, constant: 7),
        ])
        
        let priceLabel = CommonView.getCommonLabel(text: lifeTimePlanDetail.price, font: .mymediumSystemFont(ofSize: 16.pulse2Font()), alignment: .center)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.2
        lifeTimePlanInnerView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: lifeTimePlanInnerView.trailingAnchor, constant: -20),
            priceLabel.centerYAnchor.constraint(equalTo: lifeTimePlanInnerView.centerYAnchor, constant: -10),
        ])
        
        let priceDetailLabel = CommonView.getCommonLabel(text: lifeTimePlanDetail.priceDetails, font: .systemFont(ofSize: 13.pulse2Font()), lines: 2, alignment: .center)
        priceDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        priceDetailLabel.adjustsFontSizeToFitWidth = true
        priceDetailLabel.minimumScaleFactor = 0.2
        lifeTimePlanInnerView.addSubview(priceDetailLabel)
        NSLayoutConstraint.activate([
            priceDetailLabel.centerXAnchor.constraint(equalTo: priceLabel.centerXAnchor),
            priceDetailLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0),
        ])
        
        let lifeTimePlanButton = UIButton()
        lifeTimePlanView.addSubview(lifeTimePlanButton)
        lifeTimePlanButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lifeTimePlanButton.leadingAnchor.constraint(equalTo: lifeTimePlanView.leadingAnchor, constant: 0),
            lifeTimePlanButton.trailingAnchor.constraint(equalTo: lifeTimePlanView.trailingAnchor, constant: 0),
            lifeTimePlanButton.topAnchor.constraint(equalTo: lifeTimePlanView.topAnchor, constant: 0),
            lifeTimePlanButton.bottomAnchor.constraint(equalTo: lifeTimePlanView.bottomAnchor, constant: 0),
        ])
        lifeTimePlanButton.addTarget(self, action: #selector(lifeTimePlanTapped), for: .touchUpInside)
        lifeTimePlanButton.addTarget(self, action: #selector(lifeTimePlantouchDownButtonAction(_:)), for: .touchDown)
        lifeTimePlanButton.addTarget(self, action: #selector(lifeTimePlantouchUpButtonAction(_:)), for: .touchUpOutside)
        
    }
    
    @objc func lifeTimePlanTapped(_ sender: UIButton) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
            self?.lifeTimePlanView.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
            self?.lifeTimePlanView2.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.1,
                               delay: 0,
                               options: .curveLinear,
                               animations: { [weak self] in
                    self?.lifeTimePlanView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    self?.lifeTimePlanView2.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                }) { [weak self] (_) in
                    self?.plansArray.forEach { $0.isSelected = false }
                    self?.plansCollectionView.reloadData()
                    self?.plansCollectionView2.reloadData()
                    if self?.plansArray.count != 0 {
                        self?.selectedSubscriptionPlan = .lifetime
                    }
                    
                    self?.lifeTimePlanView.backgroundColor = UIColor(hexString: "FF76B7") ?? girlAppColor
                    self?.lifeTimePlanView2.backgroundColor = UIColor(hexString: "FF76B7") ?? girlAppColor
                }
            }
        }
    }
    
    @objc func lifeTimePlantouchDownButtonAction(_ sender: UIButton) {
        self.lifeTimePlanView.touchDownAnimation {}
        self.lifeTimePlanView2.touchDownAnimation {}
    }

    @objc func lifeTimePlantouchUpButtonAction(_ sender: UIButton) {
        self.lifeTimePlanView.touchUpAnimation {}
        self.lifeTimePlanView2.touchUpAnimation {}
    }
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }

    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
}


extension SalesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == reviewCollectionView{
            return salesReviewArray.count
        } else {
            return plansArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == reviewCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalesReviewCell", for: indexPath) as! SalesReviewCell
            cell.setupUI(data: salesReviewArray[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalesPlanCell", for: indexPath) as! SalesPlanCell
            cell.setupUI(data: plansArray[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == reviewCollectionView{
            return CGSize(width: DeviceSize.isiPadDevice ? 360 : (collectionView.widthOfView / 1.28), height: reviewCollectionHeight)
        } else {
            return CGSize(width: collectionView.widthOfView / 3.2, height: planCollectionHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.plansCollectionView || collectionView == self.plansCollectionView2 {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.showAnimation({
                self.lifeTimePlanView.backgroundColor = boyAppColor
                self.lifeTimePlanView2.backgroundColor = boyAppColor
                self.plansArray.forEach { $0.isSelected = false }
                self.plansArray[indexPath.row].isSelected = true
                switch indexPath.row {
                case 0:
                    self.selectedSubscriptionPlan = .weekly
                    break
                case 1:
                    self.selectedSubscriptionPlan = .threeMonths
                    break
                case 2:
                    self.selectedSubscriptionPlan = .monthly
                    break
                default:
                    self.selectedSubscriptionPlan = .threeMonths
                    break
                }
                self.plansCollectionView.reloadData()
                self.plansCollectionView2.reloadData()
                self.setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView)
                self.setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView2)
            })
        }
    }
}

extension SalesVC {
    
    @objc func purchaseButtonAction(_ sender: UIButton) {
        
        sender.showAnimation {
            // Check Network Connection
            NetworkManager.isReachable { (managedNetwork) in
                
                // Success
                //let generator = UINotificationFeedbackGenerator()
                //generator.notificationOccurred(.success)
                
                if self.selectedSubscriptionPlan == .weekly {  // Weekly Subscription
                    
                    self.purchase(purchase: InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionWeekly)
                    
                } else if self.selectedSubscriptionPlan == .monthly {  // Monthly Subscription
                    
                    self.purchase(purchase: InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionMonthly)
                    
                } else if self.selectedSubscriptionPlan == .threeMonths {  // Monthly Subscription
                    
                    self.purchase(purchase: InAppPurchaseProduct.ovulioBabyUnlockAllSubscription3Months)
                    
                } else if self.selectedSubscriptionPlan == .lifetime {  // Lifetime Subscription
                    
                    //self.purchase(purchase: InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionLifetime)
                    self.purchase(purchase: InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionLifetime1)
                    
                } else {
                    return
                }
                
            }
            
            NetworkManager.isUnreachable { (managedNetwork) in
                
                // Error
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                
                // Alert
                self.showAlert(alert: self.alertWithTitle(title: NSLocalizedString("InAppPurchase.alert.uploadError.title", comment: ""), message: NSLocalizedString("InAppPurchase.alert.uploadError.message", comment: "")))
                
            }
            
        }
        
    }
    
    
    
    func purchase(purchase: InAppPurchaseProduct) {
        
        self.addLoadingIndicator()
        self.ContinueButton.isUserInteractionEnabled = false
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        
        SwiftyStoreKit.purchaseProduct(purchase.rawValue, completion: { [self]
            result in
            
            self.removeLoadingIndicator()
            self.ContinueButton.isUserInteractionEnabled = true
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            switch result {
            case .success(let purchaseSuccess):
                print("Purchase Success: \(purchaseSuccess.productId)")
                //self.inAppPurchaseSuccess(purchaseType: .purchase)
                
                if purchase == .ovulioBabyUnlockAllSubscriptionWeekly {
                    print("Purchase Pro Weekly")
                    self.inAppPurchaseSuccess(purchaseType: .weekly)
                } else if purchase == .ovulioBabyUnlockAllSubscriptionMonthly {
                    print("Purchase Pro Monthly")
                    self.inAppPurchaseSuccess(purchaseType: .monthly)
                } else if purchase == .ovulioBabyUnlockAllSubscription3Months {
                    print("Purchase Pro 3 Months")
                    self.inAppPurchaseSuccess(purchaseType: .threeMonths)
                } else if purchase == .ovulioBabyUnlockAllSubscriptionLifetime {
                    print("Purchase Pro lifetime")
                    self.inAppPurchaseSuccess(purchaseType: .lifetime)
                } else if purchase == .ovulioBabyUnlockAllSubscriptionLifetime1 {
                    print("Purchase Pro lifetime")
                    self.inAppPurchaseSuccess(purchaseType: .lifetime)
                }
                
            case .error(let error):
                print("Purchase Error: \(error.localizedDescription)")
                
                switch error.code {
                case .paymentCancelled: // user cancelled the request, etc.
                    print("Cancelled IAP")
                default:
                    print("error IAP default")
                }
                
            }
            
            self.showAlert(alert: self.alertForPurchaseResult(result: result))
            
        })
        
    }
    
    func sendPushNotificationForAll(title: String, body: String ) {
        
        db.collection("ReceiverFCMs").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let allCodesList = querySnapshot?.documents.compactMap{ $0.documentID } ?? []
                
                for code in allCodesList {
                    print("code => \(code)")
                    PushNotificationManager.sendPushNotification(to: code, title: title, body: body )
                }
                
            }
            
        }
        
    }
    
    func inAppPurchaseSuccess(purchaseType: PurchaseOptions) {
        
        var priceString = "$9.99"  // you will get this String from SwiftyStoreKit directly without needing to format it, just use the native price
        
        var planTypeString = ""// self.plansArray[0].duration
        
        var planLocale: Locale = Locale(identifier: "en_US")
        
        
        if purchaseType == .weekly {  // Weekly Subscription
            
            planTypeString = self.plansArray[0].duration
            priceString = self.plansArray[0].dollarPrice
            planLocale = self.plansArray[0].priceLocale
            
            AppsFlyerLib.shared().logEvent(AFEventPurchase,
              withValues: [
                AFEventParamContent: "In-App Purchase Weekly",
                AFEventParamRevenue: "9.99",
                AFEventParamCurrency: "USD"
            ]);
            
        } else if purchaseType == .threeMonths {  // 3 Months Subscription
            
            planTypeString = self.plansArray[1].duration
            priceString = self.plansArray[1].dollarPrice
            planLocale = self.plansArray[1].priceLocale
            
            AppsFlyerLib.shared().logEvent(AFEventPurchase,
              withValues: [
                AFEventParamContent: "In-App Purchase 3 Months",
                AFEventParamRevenue: "29.99",
                AFEventParamCurrency: "USD"
            ]);
            
        } else if purchaseType == .monthly {  // Monthly Subscription
            
            if self.plansArray.count == 3 {
                planTypeString = self.plansArray[2].duration
                priceString = self.plansArray[2].dollarPrice
                planLocale = self.plansArray[2].priceLocale
            } else {
                planTypeString = lifeTimePlanDetail.duration
                priceString = lifeTimePlanDetail.dollarPrice
                planLocale = lifeTimePlanDetail.priceLocale
            }
            
            
            if self.isProductAtZeroDollar == true {
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(true, forKey: "shouldUserGiveAppStoreReviewToUnlockApp")
            }
            
            AppsFlyerLib.shared().logEvent(AFEventPurchase,
              withValues: [
                AFEventParamContent: "In-App Purchase Monthly",
                AFEventParamRevenue: "19.99",
                AFEventParamCurrency: "USD"
            ]);
            
        } else if purchaseType == .lifetime {  // Monthly Subscription
            
            planTypeString = lifeTimePlanDetail.duration
            priceString = lifeTimePlanDetail.dollarPrice
            planLocale = lifeTimePlanDetail.priceLocale
            
            if self.isProductAtZeroDollar == true {
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(true, forKey: "shouldUserGiveAppStoreReviewToUnlockApp")
            }
            planLocale = lifeTimePlanDetail.priceLocale
            
            AppsFlyerLib.shared().logEvent(AFEventPurchase,
              withValues: [
                AFEventParamContent: "In-App Purchase Lifetime",
                AFEventParamRevenue: "49.99",
                AFEventParamCurrency: "USD"
            ]);
            
        }
        
        if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == true {
            sendPushNotificationForAll(title: "New Subscription", body: "A user subscribed to a \(planTypeString) Plan for \(priceString), Country: \(self.getCountryCode(from: planLocale)!)")
        }
        
        
        
        let userDefaults = UserDefaults.standard
        if purchaseType == .weekly {
            userDefaults.setValue(true, forKey: "didOvulioBabyWeeklySubscription")
        } else if purchaseType == .monthly {
            userDefaults.setValue(true, forKey: "didOvulioBabyMonthlySubscription")
        } else if purchaseType == .threeMonths {
            userDefaults.setValue(true, forKey: "didOvulioBaby3MonthsSubscription")
        } else if purchaseType == .lifetime {
            userDefaults.setValue(true, forKey: "didOvulioBabyLifetimeSubscription")
        }
        
        userDefaults.setValue(true, forKey: "shouldAskUserForReviewAfterPurchase")  // ask user for review after closing this menu
        
        userDefaults.set(Date(), forKey: "purchaseDateOvulioBabyPro")
        
        
        
        var shouldUpdateCountIapMenuOpen: Bool = true
        
        if purchaseType == .restore {
            shouldUpdateCountIapMenuOpen = false
        }
        
        if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == false {
            shouldUpdateCountIapMenuOpen = false
        }
        
        if shouldUpdateCountIapMenuOpen == true {
            
            // Count how many times the IAP Menu needs to be shown until user purchases
            var countIapMenuOpen: Int = 0
            if userDefaults.value(forKey: "countIapMenuOpen") != nil {
                countIapMenuOpen = userDefaults.value(forKey: "countIapMenuOpen") as! Int
            }
            
            let db = Firestore.firestore()
            let docRefTracking = db.collection("tracking").document("CountIapMenuOpenBeforePurchase")
            docRefTracking.updateData(["\(countIapMenuOpen)" : FieldValue.increment(Int64(1))])
            
            
            // Update Lifetime Tracking Data
            let docRefTrackingSales = db.collection("tracking").document("CountInAppPurchases")
            if self.isProductAtZeroDollar == true {
                docRefTrackingSales.updateData(["freePurchase" : FieldValue.increment(Int64(1))])
            } else if purchaseType == .weekly {
                docRefTrackingSales.updateData(["weeklySubscription" : FieldValue.increment(Int64(1))])
            } else if purchaseType == .monthly {
                docRefTrackingSales.updateData(["monthlySubscription" : FieldValue.increment(Int64(1))])
            } else if purchaseType == .threeMonths {
                docRefTrackingSales.updateData(["3monthsSubscription" : FieldValue.increment(Int64(1))])
            } else if purchaseType == .lifetime {
                docRefTrackingSales.updateData(["lifetimeSubscription" : FieldValue.increment(Int64(1))])
            }
            
            
            let nowDate = self.client.referenceTime?.now()
            if nowDate != nil {
                
                // Update Monthly Tracking Data
                let currentDateMonthFormate = nowDate!.format(dateFormat: "MM-yyyy")  // Set output formate
                let docRefTrackingMonthly = docRefTrackingSales.collection(currentDateMonthFormate).document("purchaseSummary")
                
                docRefTrackingMonthly.getDocument { (document, error) in
                    
                    if let document = document, document.exists {
                        
                        if self.isProductAtZeroDollar == true {
                            docRefTrackingSales.updateData(["freePurchase" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .weekly {
                            docRefTrackingMonthly.updateData(["weeklySubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .monthly {
                            docRefTrackingMonthly.updateData(["monthlySubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .threeMonths {
                            docRefTrackingMonthly.updateData(["3monthsSubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .lifetime {
                            docRefTrackingMonthly.updateData(["lifetimeSubscription" : FieldValue.increment(Int64(1))])
                        }
                        
                    } else {
                        
                        var freePurchase: Int = 0
                        var weeklySubscriptionAmount: Int = 0
                        var monthlySubscriptionAmount: Int = 0
                        var threeMonthsSubscriptionAmount: Int = 0
                        var lifetimeSubscriptionAmount: Int = 0
                        
                        if self.isProductAtZeroDollar == true {
                            freePurchase = 1
                        } else if purchaseType == .weekly {
                            weeklySubscriptionAmount = 1
                        } else if purchaseType == .monthly {
                            monthlySubscriptionAmount = 1
                        } else if purchaseType == .threeMonths {
                            threeMonthsSubscriptionAmount = 1
                        } else if purchaseType == .lifetime {
                            lifetimeSubscriptionAmount = 1
                        }
                        
                        docRefTrackingMonthly.setData(["freePurchase" : freePurchase], merge: true)
                        docRefTrackingMonthly.setData(["weeklySubscription" : weeklySubscriptionAmount], merge: true)
                        docRefTrackingMonthly.setData(["monthlySubscription" : monthlySubscriptionAmount], merge: true)
                        docRefTrackingMonthly.setData(["3monthsSubscription" : threeMonthsSubscriptionAmount], merge: true)
                        docRefTrackingMonthly.setData(["lifetimeSubscription" : lifetimeSubscriptionAmount], merge: true)
                        
                    }
                    
                }
                
                
                // Update Daily Tracking Data
                let currentDateDayFormate = nowDate!.format(dateFormat: "dd-MM-yyyy")  // Set output formate
                let docRefTrackingDaily = docRefTrackingSales.collection(currentDateMonthFormate).document(currentDateDayFormate)
                
                docRefTrackingDaily.getDocument { (document, error) in
                    
                    if let document = document, document.exists {
                        
                        if self.isProductAtZeroDollar == true {
                            docRefTrackingSales.updateData(["freePurchase" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .weekly {
                            docRefTrackingDaily.updateData(["weeklySubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .monthly {
                            docRefTrackingDaily.updateData(["monthlySubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .threeMonths {
                            docRefTrackingDaily.updateData(["3monthsSubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .lifetime {
                            docRefTrackingDaily.updateData(["lifetimeSubscription" : FieldValue.increment(Int64(1))])
                        }
                        
                    } else {
                        
                        var freePurchase: Int = 0
                        var weeklySubscriptionAmount: Int = 0
                        var monthlySubscriptionAmount: Int = 0
                        var threeMonthsSubscriptionAmount: Int = 0
                        var lifetimeSubscriptionAmount: Int = 0
                        
                        if self.isProductAtZeroDollar == true {
                            freePurchase = 1
                        } else if purchaseType == .weekly {
                            weeklySubscriptionAmount = 1
                        } else if purchaseType == .monthly {
                            monthlySubscriptionAmount = 1
                        } else if purchaseType == .threeMonths {
                            threeMonthsSubscriptionAmount = 1
                        } else if purchaseType == .lifetime {
                            lifetimeSubscriptionAmount = 1
                        }
                        
                        docRefTrackingDaily.setData(["freePurchase" : freePurchase], merge: true)
                        docRefTrackingDaily.setData(["weeklySubscription" : weeklySubscriptionAmount], merge: true)
                        docRefTrackingDaily.setData(["monthlySubscription" : monthlySubscriptionAmount], merge: true)
                        docRefTrackingDaily.setData(["3monthsSubscription" : threeMonthsSubscriptionAmount], merge: true)
                        docRefTrackingDaily.setData(["lifetimeSubscription" : lifetimeSubscriptionAmount], merge: true)
                        
                    }
                    
                }
                
            } else {  // Else we use local date from device if realtime world clock date does not load
                
                // Update Monthly Tracking Data
                let currentDateMonthFormate = Date().format(dateFormat: "MM-yyyy")  // Set output formate
                let docRefTrackingMonthly = docRefTrackingSales.collection(currentDateMonthFormate).document("purchaseSummary")
                
                docRefTrackingMonthly.getDocument { (document, error) in
                    
                    if let document = document, document.exists {
                        
                        if self.isProductAtZeroDollar == true {
                            docRefTrackingSales.updateData(["freePurchase" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .weekly {
                            docRefTrackingMonthly.updateData(["weeklySubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .monthly {
                            docRefTrackingMonthly.updateData(["monthlySubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .threeMonths {
                            docRefTrackingMonthly.updateData(["3monthsSubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .lifetime {
                            docRefTrackingMonthly.updateData(["lifetimeSubscription" : FieldValue.increment(Int64(1))])
                        }
                        
                    } else {
                        
                        var freePurchase: Int = 0
                        var weeklySubscriptionAmount: Int = 0
                        var monthlySubscriptionAmount: Int = 0
                        var threeMonthsSubscriptionAmount: Int = 0
                        var lifetimeSubscriptionAmount: Int = 0
                        
                        if self.isProductAtZeroDollar == true {
                            freePurchase = 1
                        } else if purchaseType == .weekly {
                            weeklySubscriptionAmount = 1
                        } else if purchaseType == .monthly {
                            monthlySubscriptionAmount = 1
                        } else if purchaseType == .threeMonths {
                            threeMonthsSubscriptionAmount = 1
                        } else if purchaseType == .lifetime {
                            lifetimeSubscriptionAmount = 1
                        }
                        
                        docRefTrackingMonthly.setData(["freePurchase" : freePurchase], merge: true)
                        docRefTrackingMonthly.setData(["weeklySubscription" : weeklySubscriptionAmount], merge: true)
                        docRefTrackingMonthly.setData(["monthlySubscription" : monthlySubscriptionAmount], merge: true)
                        docRefTrackingMonthly.setData(["3monthsSubscription" : threeMonthsSubscriptionAmount], merge: true)
                        docRefTrackingMonthly.setData(["lifetimeSubscription" : lifetimeSubscriptionAmount], merge: true)
                        
                    }
                    
                }
                
                
                // Update Daily Tracking Data
                let currentDateDayFormate = Date().format(dateFormat: "dd-MM-yyyy")  // Set output formate
                let docRefTrackingDaily = docRefTrackingSales.collection(currentDateMonthFormate).document(currentDateDayFormate)
                
                docRefTrackingDaily.getDocument { (document, error) in
                    
                    if let document = document, document.exists {
                        
                        if self.isProductAtZeroDollar == true {
                            docRefTrackingSales.updateData(["freePurchase" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .weekly {
                            docRefTrackingDaily.updateData(["weeklySubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .monthly {
                            docRefTrackingDaily.updateData(["monthlySubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .threeMonths {
                            docRefTrackingDaily.updateData(["3monthsSubscription" : FieldValue.increment(Int64(1))])
                        } else if purchaseType == .lifetime {
                            docRefTrackingDaily.updateData(["lifetimeSubscription" : FieldValue.increment(Int64(1))])
                        }
                        
                    } else {
                        
                        var freePurchase: Int = 0
                        var weeklySubscriptionAmount: Int = 0
                        var monthlySubscriptionAmount: Int = 0
                        var threeMonthsSubscriptionAmount: Int = 0
                        var lifetimeSubscriptionAmount: Int = 0
                        
                        if self.isProductAtZeroDollar == true {
                            freePurchase = 1
                        } else if purchaseType == .weekly {
                            weeklySubscriptionAmount = 1
                        } else if purchaseType == .monthly {
                            monthlySubscriptionAmount = 1
                        } else if purchaseType == .threeMonths {
                            threeMonthsSubscriptionAmount = 1
                        } else if purchaseType == .threeMonths {
                            lifetimeSubscriptionAmount = 1
                        }
                        
                        docRefTrackingDaily.setData(["freePurchase" : freePurchase], merge: true)
                        docRefTrackingDaily.setData(["weeklySubscription" : weeklySubscriptionAmount], merge: true)
                        docRefTrackingDaily.setData(["monthlySubscription" : monthlySubscriptionAmount], merge: true)
                        docRefTrackingDaily.setData(["3monthsSubscription" : threeMonthsSubscriptionAmount], merge: true)
                        docRefTrackingDaily.setData(["lifetimeSubscription" : lifetimeSubscriptionAmount], merge: true)
                        
                    }

                }

            }

        }

        // Feedback Generator
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        
        // Show Confetti
        self.confettiView.startAnimating()
        let confettiViewTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(stopConfettiAlertAnimation), userInfo: nil, repeats: false)
        
        // Make Tick animation
        let alertView = AlertAppleMusic17View(title: NSLocalizedString("SalesVC.spalert.success.title", comment: NSLocalizedString("SalesVC.spalert.success.message", comment: "")), subtitle: "", icon: .heart)
        alertView.present(on: self.view)
        
        
        // Dismiss after 1.7s
        self.delay(1.7) {
            //self.dismiss(animated: true, completion: nil)
            if let action = self.didPurchaseSuccessfully {
                action()
            }
            self.dismiss(animated: true) {
                if let action = self.delegateShowReviewScreenProtocol {
                    action.needToShowReviewScreen()
                }
            }
        }
        
        
        
    }
    
    @objc func stopConfettiAlertAnimation() {
        self.confettiView.stopAnimating()
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    
    public enum PurchaseOptions: UInt {
        
        case weekly
        
        case monthly
        
        case threeMonths
        
        case lifetime
        
        case restore
        
    }
    
}

extension SalesVC {
    
    func alertWithTitle(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = appColor
        alert.addAction(UIAlertAction(title: NSLocalizedString("UIAlertController.okButton", comment: ""), style: .cancel, handler: nil))
        
        return alert
        
    }
    
    
    func showAlert(alert: UIAlertController?) {
        
        guard let _ = self.presentedViewController else {
            
            if alert != nil {
                self.present(alert!, animated: true, completion: nil)
            }
            
            return
            
        }
        
    }
    
    
    func alertForProductRetrievalInfo(result: RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            
            let priceString = product.localizedPrice!
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
            
        } else if let invalidProductID = result.invalidProductIDs.first {
            
            return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForProductRetrievalInfo.invalidProductIDs.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForProductRetrievalInfo.invalidProductIDs.message", comment: "") + "\(invalidProductID)")
            
        } else {
            
            let errorString = result.error?.localizedDescription ?? NSLocalizedString("InAppPurchase.alertForProductRetrievalInfo.default.message", comment: "")
            return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForProductRetrievalInfo.invalidProductIDs.title", comment: ""), message: errorString)
            
        }
        
    }
    
    
    
    func alertForPurchaseResult(result: PurchaseResult) -> UIAlertController? {
        
        /*
        case .success(let product):
            print("Purchase successful: \(product.productId)")
            return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.success.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.success.message", comment: ""))
        */
        
        switch result {
        case .success(purchase: let purchase):
            return nil
        case .error(let error):
            print("Purchase failed: \(error)")
            
            switch error.code {
            case .unknown: return alertWithTitle(title: "Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.clientInvalid.message", comment: ""))
            //case .paymentCancelled: // user cancelled the request, etc.
                //return
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.paymentInvalid.message", comment: ""))
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.paymentNotAllowed.message", comment: ""))
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.storeProductNotAvailable.message", comment: ""))
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.cloudServicePermissionDenied.message", comment: ""))
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.cloudServiceNetworkConnectionFailed.message", comment: ""))
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.cloudServiceRevoked.message", comment: ""))
            default:
                return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: NSLocalizedString("InAppPurchase.alert.uploadError.title", comment: ""))
                //return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForPurchaseResult.error.title", comment: ""), message: (error as NSError).localizedDescription)
            }
            
        }
        
    }
    
    
    
    func alertForRestorePurchases(result: RestoreResults) -> UIAlertController? {
        
        if result.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(result.restoreFailedPurchases)")
            return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForRestorePurchases.restoreFailedPurchases.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForRestorePurchases.restoreFailedPurchases.message", comment: ""))
        } else if result.restoredPurchases.count > 0 {
            print("Restore Success: \(result.restoredPurchases)")
            return nil
            //return alertPurchaseSuccessRestartApp(title: NSLocalizedString("InAppPurchase.alertForRestorePurchases.restoredPurchases.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForRestorePurchases.restoredPurchases.message", comment: ""))
        } else {
            print("Nothing to Restore")
            return alertWithTitle(title: NSLocalizedString("InAppPurchase.alertForRestorePurchases.nothingToRestore.title", comment: ""), message: NSLocalizedString("InAppPurchase.alertForRestorePurchases.nothingToRestore.message", comment: ""))
        }
        
    }
    
    
    func getIapInfoMonthlyPurchaseOnlyOption() {
        
        self.purchaseButtonTitle = ""
        
        var str = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButtonsSubtitleLabel.SummerDiscountShortTime.text", comment: "")
        //self.purchaseButtonsSubtitleLabel.attributedText = self.attributedPurchaseSubtitleButtonTextMakeBold(withString: str, boldString: [String(str.split(separator: ",")[1])])
        
        
        SwiftyStoreKit.retrieveProductsInfo([InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionMonthly.rawValue], completion: {
            result in
            
            if result.error != nil {
                print("Error: retrieveProductsInfo")
                return
            }
            
            
            // One Time Purchase
            if let product = result.retrievedProducts.first {
                
                if product.localizedPrice != nil {
                    
                    // Everything OK, String is available
                    self.inAppPurchasePrice = product.localizedPrice!
                    var priceStringCurrency = product.localizedPrice!.filter {!$0.isWhitespace}
                    priceStringCurrency = self.getCurrencyFormattedPrice(from: 0.0, locale: product.priceLocale)!
                    self.purchaseButtonTitle = priceStringCurrency + " " + NSLocalizedString("SalesVC.plans.1Month.details.monthly.text", comment: "")
                    self.ContinueButton.subtitleLabel.text = self.purchaseButtonTitle
                    
                    if product.price == 0.0 {
                        self.isProductAtZeroDollar = true
                        self.productAtZeroDollar = .monthly
                    }
                    
                    self.getComparePrice()
                    
                } else {
                    
                    // For countries where String doesn't load properly
                    self.ContinueButton.subtitleLabel.text = NSLocalizedString("SalesVC.plans.1Month.details.monthly.text", comment: "")
                    
                }
                
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                //print("Error: " + String(describing: result.error))
                print("Error: retrieveProductsInfo")
            }
            
            
            // Monthly Subscription
            if result.retrievedProducts.count == 2 {
                // continue
            } else {
                // break
                return
            }
            
        })
        
    }
    
    
    func getIapInfoLifetimePurchaseOnlyOption() {
        
        self.purchaseButtonTitle = ""
        
        var str = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButtonsSubtitleLabel.SummerDiscountShortTime.text", comment: "")
        //self.purchaseButtonsSubtitleLabel.attributedText = self.attributedPurchaseSubtitleButtonTextMakeBold(withString: str, boldString: [String(str.split(separator: ",")[1])])
        
        
        SwiftyStoreKit.retrieveProductsInfo([InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionLifetime1.rawValue], completion: {
            result in
            
            if result.error != nil {
                print("Error: retrieveProductsInfo")
                return
            }
            
            
            // One Time Purchase
            if let product = result.retrievedProducts.first {
                
                if product.localizedPrice != nil {
                    
                    // Everything OK, String is available
                    self.inAppPurchasePrice = product.localizedPrice!
                    var priceStringCurrency = product.localizedPrice!.filter {!$0.isWhitespace}
                    self.purchaseButtonTitle = priceStringCurrency + " " + NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.subtitleLabel.text", comment: "")
                    self.ContinueButton.subtitleLabel.text = self.purchaseButtonTitle
                    
                    if product.price == 0.0 {
                        self.isProductAtZeroDollar = true
                        self.productAtZeroDollar = .lifetime
                    }
                    
                    self.getComparePrice()
                    
                } else {
                    
                    // For countries where String doesn't load properly
                    self.ContinueButton.subtitleLabel.text = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.subtitleLabel.text", comment: "")
                    
                }
                
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                //print("Error: " + String(describing: result.error))
                print("Error: retrieveProductsInfo")
            }
            
            
            // Monthly Subscription
            if result.retrievedProducts.count == 2 {
                // continue
            } else {
                // break
                return
            }
            
        })
        
    }
    
    
    func getComparePrice() {
        
        // Add Monthly Compare Price
        SwiftyStoreKit.retrieveProductsInfo([InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionLifetime.rawValue], completion: {
            result in
            
            if result.error != nil {
                print("Error: retrieveProductsInfo")
                return
            }
            
            
            // One Time Purchase
            if let product = result.retrievedProducts.first {
                
                if product.localizedPrice != nil {
                    
                    // Everything OK, String is available
                    var priceStringCurrency = product.localizedPrice!.filter {!$0.isWhitespace}
                    let weeklyComparePrice = priceStringCurrency //+ "/" + NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.subtitleLabel.text.month", comment: "")
                    self.purchaseButtonTitle = weeklyComparePrice + " " + self.purchaseButtonTitle
                    
                    self.ContinueButton.subtitleLabel.text = self.purchaseButtonTitle
                    
                    // Add Compare Price
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.purchaseButtonTitle)
                    let somePartStringRange = (self.purchaseButtonTitle as NSString).range(of: weeklyComparePrice)
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: somePartStringRange)
                    attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.8392, green: 0.8392, blue: 0.8392, alpha: 1.0) /* #d6d6d6 */ , range: somePartStringRange)
                    
                    self.ContinueButton.subtitleLabel.attributedText = attributeString
                    self.ContinueButton.subtitleLabel.font = UIFont(name: "Poppins-Medium", size: 15.0)
                    
                } else {
                    
                    // For countries where String doesn't load properly
                    self.ContinueButton.subtitleLabel.text = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.subtitleLabel.text", comment: "")
                    
                }
                
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                //print("Error: " + String(describing: result.error))
                print("Error: retrieveProductsInfo")
            }
            
            
            // Monthly Subscription
            if result.retrievedProducts.count == 2 {
                // continue
            } else {
                // break
                return
            }
            
        })
        
    }
    
    
    func getIapInfo() {
        
        let subscriptionWeekly = InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionWeekly
        SwiftyStoreKit.retrieveProductsInfo([subscriptionWeekly.rawValue], completion: {
            result in
            
            defer {
                if let product = result.retrievedProducts.first, let dividedPrice = self.getCurrencyFormattedPrice(from: product.price.doubleValue, locale: product.priceLocale) {
                    self.getPlanValuesFor3Months(weeklyPrice: dividedPrice)
                } else {
                    self.getPlanValuesFor3Months(weeklyPrice: "$9.99")
                }
            }
            
            if result.error != nil {
                self.plansArray[0] = PlansModel(headline: "", duration: "SalesVC.plans.1week.headline.text"~, durationDetails: "SalesVC.plans.1week.details.text"~, beforePrice: "0", price: "$9.99", priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "", priceLocale: Locale(identifier: "en_US"), isSelected: false, dollarPrice: "$9.99", subscriptionType: "weekly")
                self.ContinueButton.isHidden = false
                self.continueButtonGradientImageView.isHidden = false
                self.plansCollectionView.reloadData()
                self.plansCollectionView2.reloadData()
                print("Error: retrieveProductsInfo")
                return
            }
            
            if let product = result.retrievedProducts.first {
                
                if product.localizedPrice != nil {
                    
                    //print("getCountryCode(from: product.priceLocale) \(self.getCountryCode(from: product.priceLocale)!)")
                    
                    // Everything OK, String is available
                    let priceStringCurrency = product.localizedPrice!.filter {!$0.isWhitespace}
                    self.plansArray[0] = PlansModel(headline: "", duration: "SalesVC.plans.1week.headline.text"~, durationDetails: "SalesVC.plans.1week.details.text"~, beforePrice: "0", price: priceStringCurrency, priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "", priceLocale: product.priceLocale, isSelected: false, dollarPrice: "$\(product.price)", subscriptionType: "weekly")
                    self.ContinueButton.isHidden = false
                    self.continueButtonGradientImageView.isHidden = false
                    self.plansCollectionView.reloadData()
                    self.plansCollectionView2.reloadData()
                } else {
                    
                    // For countries where String doesn't load properly
                    let purchaseButtonTitleText = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.titleLabel.text", comment: "")
//                    self.purchaseButtonsPriceLabel.text = purchaseButtonTitleText.substring(to: purchaseButtonTitleText.index(before: purchaseButtonTitleText.endIndex))
                    
                    return
                    
                }
                
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                //print("Error: " + String(describing: result.error))
                print("Error: retrieveProductsInfo")
            }
            
        })
    }
    
    func getPlanValuesFor3Months(weeklyPrice: String) {
        
        let subscription3Months = InAppPurchaseProduct.ovulioBabyUnlockAllSubscription3Months
        SwiftyStoreKit.retrieveProductsInfo([subscription3Months.rawValue], completion: {
            result in
            
            defer {
                if let product = result.retrievedProducts.first, let dividedPrice = self.getCurrencyFormattedPrice(from: product.price.doubleValue, locale: product.priceLocale) {
                    self.getPlanValuesForMonthly(weeklyPrice: dividedPrice)
                }else{
                    self.getPlanValuesForMonthly(weeklyPrice: "$9.99")
                }
            }
            if result.error != nil {
                self.plansArray[1] = PlansModel(headline: "SalesVC.plans.3Months.typeTitle.headline.text"~, duration: "SalesVC.plans.3Months.headline.text"~, durationDetails: "$29.99 \("SalesVC.plans.3Months.details.text"~)", beforePrice: weeklyPrice, price: "$2.50", priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.3Months.discount.headline.text"~, priceLocale: Locale(identifier: "en_US"), isSelected: self.selectedSubscriptionPlan == nil ? true : false, dollarPrice: "$9.99", subscriptionType: "3months")
                self.selectedSubscriptionPlan = .threeMonths
                self.ContinueButton.isHidden = false
                self.continueButtonGradientImageView.isHidden = false
                self.plansCollectionView.reloadData()
                self.plansCollectionView2.reloadData()
                print("Error: retrieveProductsInfo")
                return
            }
            
            if let product = result.retrievedProducts.first {
                
                if product.localizedPrice != nil {
                    
                    // Everything OK, String is available
                    let priceStringCurrency = product.localizedPrice!.filter {!$0.isWhitespace}
                    if let dividedPrice = self.getCurrencyFormattedPrice(from: product.price.doubleValue / 12, locale: product.priceLocale) {
                        self.plansArray[1] = PlansModel(headline: "SalesVC.plans.3Months.typeTitle.headline.text"~, duration: "SalesVC.plans.3Months.headline.text"~, durationDetails: "\(priceStringCurrency) \("SalesVC.plans.3Months.details.text"~)", beforePrice: weeklyPrice, price: dividedPrice, priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.3Months.discount.headline.text"~, priceLocale: product.priceLocale, isSelected: self.selectedSubscriptionPlan == nil ? true : false, dollarPrice: "$\(product.price)", subscriptionType: "3months")
                        self.selectedSubscriptionPlan = .threeMonths
                        self.ContinueButton.isHidden = false
                        self.continueButtonGradientImageView.isHidden = false
                        self.plansCollectionView.reloadData()
                        self.plansCollectionView2.reloadData()
                    }
                    // Calculate weekly price here by subtracting price through 12
                    
                } else {
                    // For countries where String doesn't load properly
                    let purchaseButtonTitleText = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.titleLabel.text", comment: "")
//                    self.purchaseButtonsPriceLabel.text = purchaseButtonTitleText.substring(to: purchaseButtonTitleText.index(before: purchaseButtonTitleText.endIndex))
                    return
                }
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                //print("Error: " + String(describing: result.error))
                print("Error: retrieveProductsInfo")
            }
            
        })
        
    }
    
    func getPlanValuesForMonthly(weeklyPrice: String) {
        
        let subscriptionMonthly = InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionMonthly
        SwiftyStoreKit.retrieveProductsInfo([subscriptionMonthly.rawValue], completion: {
            result in
            
            defer {
                if self.plansArray.count != 0 {
                    self.getPlanValuesForLifeTime()
                }
            }
            
            if result.error != nil {
                self.plansArray[2] = PlansModel(headline: "SalesVC.plans.1Month.typeTitle.headline.text"~, duration: "SalesVC.plans.1Month.headline.text"~, durationDetails: "$19.99 \("SalesVC.plans.1Month.details.text"~)", beforePrice: weeklyPrice, price: "$5.00", priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.1Month.discount.headline.text"~, priceLocale: Locale(identifier: "en_US"), isSelected: false, dollarPrice: "$9.99", subscriptionType: "monthly")
                self.ContinueButton.isHidden = false
                self.continueButtonGradientImageView.isHidden = false
                self.plansCollectionView.reloadData()
                self.plansCollectionView2.reloadData()
                print("Error: retrieveProductsInfo")
                return
            }
            
            
            if let product = result.retrievedProducts.first {
                
                if product.localizedPrice != nil {
                    
                    // Everything OK, String is available
                    let priceStringCurrency = product.localizedPrice!.filter {!$0.isWhitespace}
                    
                    // Calculate weekly price here by subtracting price through 4
                    var comparePriceValue: Double = product.price.doubleValue / 4
                    
                    if product.price == 0.0 {
                        self.isProductAtZeroDollar = true
                        self.productAtZeroDollar = .monthly
                    }
                    
                    // Now check if isMonthlyIntroductoryOfferActive is set to true in Firebase which means an introductory free offer is active at the moment
                    var isMonthlyIntroductoryOfferActive: Bool = false
                    
                    let db = Firestore.firestore()
                    let docRefTracking = db.collection("tracking").document("CountInAppPurchases")
                    docRefTracking.getDocument { (document, error) in
                        
                        if let document = document, document.exists {
                            
                            if let isMonthlyIntroductoryOfferActiveFirebaseValue = document.data()!["isMonthlyIntroductoryOfferActive"] as? Bool {
                                
                                print("isMonthlyIntroductoryOfferActiveFirebaseValue \(isMonthlyIntroductoryOfferActiveFirebaseValue)")
                                isMonthlyIntroductoryOfferActive = isMonthlyIntroductoryOfferActiveFirebaseValue
                                
                                if isMonthlyIntroductoryOfferActive == true {
                                    self.isProductAtZeroDollar = true
                                    self.productAtZeroDollar = .monthly
                                    comparePriceValue = 0.0
                                }
                                
                                self.createMonthlyPlansModelBoxes(weeklyPrice: weeklyPrice, product: product, comparePriceValue: comparePriceValue, priceStringCurrency: priceStringCurrency)
                                
                            } else {
                                
                                self.createMonthlyPlansModelBoxes(weeklyPrice: weeklyPrice, product: product, comparePriceValue: comparePriceValue, priceStringCurrency: priceStringCurrency)
                                
                            }
                            
                        } else {
                            
                            self.createMonthlyPlansModelBoxes(weeklyPrice: weeklyPrice, product: product, comparePriceValue: comparePriceValue, priceStringCurrency: priceStringCurrency)
                            
                        }
                        
                    }
                    
                } else {
                    
                    // For countries where String doesn't load properly
                    let purchaseButtonTitleText = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.titleLabel.text", comment: "")
//                    self.purchaseButtonsPriceLabel.text = purchaseButtonTitleText.substring(to: purchaseButtonTitleText.index(before: purchaseButtonTitleText.endIndex))
                    
                    return
                    
                }
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                //print("Error: " + String(describing: result.error))
                print("Error: retrieveProductsInfo")
            }
            
        })
        
    }
    
    
    func createMonthlyPlansModelBoxes(weeklyPrice: String, product: SKProduct, comparePriceValue: Double, priceStringCurrency: String) {
        
        if let dividedPrice = self.getCurrencyFormattedPrice(from: comparePriceValue, locale: product.priceLocale) {
            
            if self.isProductAtZeroDollar == true {
                self.plansArray = []
                self.planCollectionHeight = 0
                for view in self.view.subviews {
                    view.removeFromSuperview()
                }
                DispatchQueue.main.async {
                    self.lifeTimePlanDetail = PlansModel(headline: "SalesVC.plans.lifetime.typeTitle.headline.text"~, duration: "SalesVC.plans.1Month.headline.text"~, durationDetails: "SalesVC.plans.1Month.details.afterword.text"~ + "\(priceStringCurrency) \("SalesVC.plans.1Month.details.text"~)", beforePrice: weeklyPrice, price: dividedPrice, priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.1Month.fullDiscount.headline.text"~, priceLocale: product.priceLocale, isSelected: true, dollarPrice: "$\(product.price)", subscriptionType: "monthly")
                    
                    self.selectedSubscriptionPlan = .monthly
                    self.ContinueButton.isHidden = false
                    self.continueButtonGradientImageView.isHidden = false
                    self.plansCollectionView.reloadData()
                    self.plansCollectionView2.reloadData()
                    self.setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView)
                    self.setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView2)
                    
                    self.viewDidLoad()
                    self.lifeTimePlanTapped(UIButton())
                }
            } else {
                self.plansArray[2] = PlansModel(headline: "SalesVC.plans.1Month.typeTitle.headline.text"~, duration: "SalesVC.plans.1Month.headline.text"~, durationDetails: "\(priceStringCurrency) \("SalesVC.plans.1Month.details.text"~)", beforePrice: weeklyPrice, price: dividedPrice, priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.1Month.discount.headline.text"~, priceLocale: product.priceLocale, isSelected: false, dollarPrice: "$\(product.price)", subscriptionType: "monthly")
                self.ContinueButton.isHidden = false
                self.continueButtonGradientImageView.isHidden = false
                self.plansCollectionView.reloadData()
                self.plansCollectionView2.reloadData()
            }
            
        }
        
    }
    
    func getPlanValuesForLifeTime() {
        
        if self.productAtZeroDollar == .monthly {
            return  // To avoid loading lifetime purchase and writing above monthly free purchase
        }
        
        let subscriptionLifetime = InAppPurchaseProduct.ovulioBabyUnlockAllSubscriptionLifetime
        SwiftyStoreKit.retrieveProductsInfo([subscriptionLifetime.rawValue], completion: {
            result in
            
            if result.error != nil {
                self.lifeTimePlanDetail = PlansModel(headline: "SalesVC.plans.lifetime.typeTitle.headline.text"~, duration: "SalesVC.plans.lifetime.headline.text"~, durationDetails: "$49.99 \("SalesVC.plans.lifetime.details.text"~)", beforePrice: "0", price: "0.99", priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.lifetime.discount.headline.text"~, priceLocale: Locale(identifier: "en_US"), isSelected: false, dollarPrice: "$49.99", subscriptionType: "lifetime")
                self.selectedSubscriptionPlan = .lifetime
                self.ContinueButton.isHidden = false
                self.continueButtonGradientImageView.isHidden = false
                self.plansCollectionView.reloadData()
                self.plansCollectionView2.reloadData()
                self.setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView)
                self.setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView2)
                print("Error: retrieveProductsInfo")
                return
            }
            
            if let product = result.retrievedProducts.first {
                
                if product.localizedPrice != nil {
                    
                    // Everything OK, String is available
                    let priceStringCurrency = product.localizedPrice!.filter {!$0.isWhitespace}
                    
                    if product.price == 0.0 {
                        self.isProductAtZeroDollar = true
                        self.productAtZeroDollar = .lifetime
                    }
                    
                    if let dividedPrice = self.getCurrencyFormattedPrice(from: product.price.doubleValue / 50, locale: product.priceLocale) {
                        self.lifeTimePlanDetail = PlansModel(headline: "SalesVC.plans.lifetime.typeTitle.headline.text"~, duration: "SalesVC.plans.lifetime.headline.text"~, durationDetails: "\(priceStringCurrency) \("SalesVC.plans.lifetime.details.text"~)", beforePrice: "0", price: dividedPrice, priceDetails: "SalesVC.plans.1week.priceDetails.perWeek.text"~, discount: "SalesVC.plans.lifetime.discount.headline.text"~, priceLocale: product.priceLocale, isSelected: self.selectedSubscriptionPlan == nil ? true : false, dollarPrice: "$\(product.price)", subscriptionType: "lifetime")
                        
                        self.selectedSubscriptionPlan = .lifetime
                        self.ContinueButton.isHidden = false
                        self.continueButtonGradientImageView.isHidden = false
                        self.plansCollectionView.reloadData()
                        self.plansCollectionView2.reloadData()
                        self.setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView)
                        self.setupLifetimePlanView(lifeTimePlanView: self.lifeTimePlanView2)
                    }
                    // Calculate weekly price here by subtracting price through 12
                    
                } else {
                    // For countries where String doesn't load properly
                    let purchaseButtonTitleText = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.titleLabel.text", comment: "")
//                    self.purchaseButtonsPriceLabel.text = purchaseButtonTitleText.substring(to: purchaseButtonTitleText.index(before: purchaseButtonTitleText.endIndex))
                    return
                }
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                //print("Error: " + String(describing: result.error))
                print("Error: retrieveProductsInfo")
            }
            
        })
        
    }
    
    func getCurrencyFormattedPrice(from value: Double, locale: Locale) -> String? {
        
        // Create a number formatter
        let numberFormatter = NumberFormatter()

        // Set the provided locale
        numberFormatter.locale = locale

        // Set the desired number style
        numberFormatter.numberStyle = .currency

        // Convert the double value to a formatted price string
        return numberFormatter.string(from: NSNumber(value: value))
        
    }
    
    
    func getCountryCode(from locale: Locale) -> String? {
        
        let localeIdentifier = locale.identifier
        let nsLocale = NSLocale(localeIdentifier: localeIdentifier)
        if let countryCode = nsLocale.object(forKey: .countryCode) as? String {
            return countryCode
        }
        
        return nil
        
    }
    
}



class PurchaseButtonViewSmaller: UIView {
    
    let titleLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = UIFont(name: "Poppins-Bold", size: 18.0)
        labelText.textColor = UIColor.white
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
    let subtitleLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = UIFont(name: "Poppins-Bold", size: 17.0)
        labelText.textColor = UIColor.white  //UIColor(red: 0.8392, green: 0.8392, blue: 0.8392, alpha: 1.0) /* #d6d6d6 */
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
    let buttonReaction: UIButton = UIButton()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = buttonAppLightColor
        self.layer.cornerRadius = 16.0
        
        
        
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0).isActive = true
        
        titleLabel.text = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.titleLabel.text", comment: "")
        
        
        
        
        
        self.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: -1.0).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0).isActive = true
        
        subtitleLabel.text = NSLocalizedString("InAppPurchaseOfferMenu.purchaseButton.subtitleLabel.text", comment: "")
        
        
        
        
        
        self.addSubview(buttonReaction)
        buttonReaction.translatesAutoresizingMaskIntoConstraints = false
        buttonReaction.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        buttonReaction.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        buttonReaction.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true
        buttonReaction.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0).isActive = true
        
        
        /*
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.55
        self.layer.shadowColor = appColors().accentColor.cgColor
        //self.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
        self.layer.masksToBounds = false
        */
        
        
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            titleLabel.font = UIFont(name: "Poppins-Bold", size: 26.0)
            subtitleLabel.font = UIFont(name: "Poppins-Regular", size: 15.0)
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6.0).isActive = true
        } else if Device.size() <= Size.screen4_7Inch {
            print("Device is iPhone 6s or smaller")
            titleLabel.font = UIFont(name: "Poppins-Bold", size: 20.0)
            subtitleLabel.font = UIFont(name: "Poppins-Regular", size: 10.0)
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6.0).isActive = true
        } else {
            titleLabel.font = UIFont(name: "Poppins-Bold", size: 22.0)
            subtitleLabel.font = UIFont(name: "Poppins-Regular", size: 15.0)
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
