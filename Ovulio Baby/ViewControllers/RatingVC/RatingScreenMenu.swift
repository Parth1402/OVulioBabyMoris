//
//  RatingScreenMenu.swift
//  Love League Calendar
//
//  Created by Maurice Wirth on 07.05.24.
//

import UIKit
import Device
import Malert
import FirebaseFirestore


class RatingScreenMenu: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    let backgroundShapeImageView: UIImageView = {
//        
//        let imageViewBackgroundShape = UIImageView()
//        imageViewBackgroundShape.backgroundColor = UIColor.clear
//        imageViewBackgroundShape.contentMode = .scaleAspectFill
//        imageViewBackgroundShape.image = UIImage(named: "Background Love League Calendar Game.jpg")
//        imageViewBackgroundShape.clipsToBounds = true
//        
//        return imageViewBackgroundShape
//        
//    }()
//    
//    
//    let bottomIllustrationImageView: UIImageView = {
//        
//        let imageViewBottomIllustration = UIImageView()
//        imageViewBottomIllustration.backgroundColor = UIColor.clear
//        imageViewBottomIllustration.contentMode = .scaleToFill
//        imageViewBottomIllustration.image = UIImage(named: "Love League Calendar Game Bottom Illustration")
//        
//        return imageViewBottomIllustration
//        
//    }()
//    
//    
//    let bottomBarImageView: UIImageView = {
//        
//        let imageViewBottomIllustration = UIImageView()
//        imageViewBottomIllustration.backgroundColor = UIColor.clear
//        imageViewBottomIllustration.contentMode = .scaleToFill
//        imageViewBottomIllustration.image = UIImage(named: "Love League Calendar Menu Bottom Bar.jpg")
//        
//        return imageViewBottomIllustration
//        
//    }()
    
    
    let illustrationImageView: UIImageView = {
        
        let imageViewLogo = UIImageView()
        imageViewLogo.backgroundColor = UIColor.clear
        imageViewLogo.contentMode = .scaleAspectFit
        imageViewLogo.image = UIImage(named: "ReviewIllustration")
        imageViewLogo.clipsToBounds = true
        
        return imageViewLogo
        
    }()
    
    
    let headlineLabel: UITextView = {
        
        let labelHeadline = UITextView()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .center
        labelHeadline.font = .boldSystemFont(ofSize: 24.pulse2Font())
        labelHeadline.isEditable = false
        labelHeadline.isUserInteractionEnabled = true
        labelHeadline.isScrollEnabled = false
        labelHeadline.textAlignment = .center
        
        return labelHeadline
        
    }()
    
    
    let subtitleLabel: UILabel = {
        
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.font = UIFont(name: "Poppins-Regular", size: 16.0)
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .center
        labelHeadline.adjustsFontSizeToFitWidth = true
        labelHeadline.numberOfLines = 0
        
        return labelHeadline
        
    }()

    
    let subtitleLabel2: UILabel = {
        
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.font = UIFont(name: "Poppins-Regular", size: 16.0)
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .center
        labelHeadline.adjustsFontSizeToFitWidth = true
        labelHeadline.numberOfLines = 0
        
        return labelHeadline
        
    }()
    
    
    let reviewNowButton: UIButton = {
        
        let buttonReviewNow = UIButton()
        buttonReviewNow.backgroundColor = appColor
        buttonReviewNow.titleLabel?.font = .myBoldSystemFont(ofSize: 16)
//        buttonReviewNow.titleLabel?.font = .boldSystemFont(ofSize: 20)
        buttonReviewNow.setTitleColor(.white, for: .normal)
        buttonReviewNow.setTitle(NSLocalizedString("RatingScreenMenu.reviewNowButton.title", comment: ""), for: .normal)
        buttonReviewNow.layer.cornerRadius = 17.0
        
        return buttonReviewNow
        
    }()
    
    
    let uploadScreenshotButton: UIButton = {
        
        let buttonReviewNow = UIButton()
        buttonReviewNow.backgroundColor = UIColor.white
        buttonReviewNow.titleLabel?.font = .myBoldSystemFont(ofSize: 16)
//        buttonReviewNow.titleLabel?.font = .boldSystemFont(ofSize: 20)
        buttonReviewNow.setTitleColor(appColor, for: .normal)
        buttonReviewNow.setTitle(NSLocalizedString("RatingScreenMenu.uploadScreenshotButton.title", comment: ""), for: .normal)
        buttonReviewNow.layer.cornerRadius = 17.0
        
        return buttonReviewNow
        
    }()
    
    
    let reviewAlertView = ReviewAlertView()
    var malert: Malert? = nil
    
    var imagePicker = UIImagePickerController()
    
    var didVisitAppStoreForReview: Bool = false
    
    var tapUploadScreenshotButtonClicksTracked: Bool = false
    var tapOpenAppStoreClicksTracked: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        self.view.setUpBackground()
        
//        self.view.addSubview(backgroundShapeImageView)
//        backgroundShapeImageView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundShapeImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
//        backgroundShapeImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
//        backgroundShapeImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
//        backgroundShapeImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
//        
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            // Device is iPad
//            self.backgroundShapeImageView.image = UIImage(named: "Background Love League Calendar Game iPad.jpg")
//        }
        
        
        
        
//        let bottomIllustrationImageViewWidth = UIScreen.main.bounds.width + 4.0
//        var bottomIllustrationImageViewHeight = (621.0 / 1200.0) * bottomIllustrationImageViewWidth
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            // Device is iPad
//            self.bottomIllustrationImageView.image = UIImage(named: "Love League Calendar Game Bottom Illustration iPad")
//            bottomIllustrationImageViewHeight = (692.0 / 1800.0) * bottomIllustrationImageViewWidth
//        }
//        
//        self.view.addSubview(bottomIllustrationImageView)
//        bottomIllustrationImageView.translatesAutoresizingMaskIntoConstraints = false
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            // Device is iPad
//            bottomIllustrationImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
//        } else {
//            bottomIllustrationImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
//        }
//        bottomIllustrationImageView.widthAnchor.constraint(equalToConstant: bottomIllustrationImageViewWidth).isActive = true
//        bottomIllustrationImageView.heightAnchor.constraint(equalToConstant: bottomIllustrationImageViewHeight).isActive = true
//        bottomIllustrationImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
//        
//        
//        
//        
//        
//        self.view.addSubview(bottomBarImageView)
//        bottomBarImageView.translatesAutoresizingMaskIntoConstraints = false
//        bottomBarImageView.topAnchor.constraint(equalTo: self.bottomIllustrationImageView.bottomAnchor, constant: -1.0).isActive = true
//        bottomBarImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
//        bottomBarImageView.widthAnchor.constraint(equalToConstant: bottomIllustrationImageViewWidth).isActive = true
//        bottomBarImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        
        
        
        
        
        var illustrationImageViewWidth = UIScreen.main.bounds.width
        var illustrationImageViewHeight = illustrationImageViewWidth * 0.65
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Device is iPad
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {  // landscape mode
                illustrationImageViewWidth = UIScreen.main.bounds.height * 0.8
                illustrationImageViewHeight = UIScreen.main.bounds.height * 0.45
            } else {  // portrait mode
                illustrationImageViewHeight = UIScreen.main.bounds.width * 0.55
            }
        } else {
            illustrationImageViewHeight = illustrationImageViewWidth * 0.65
        }
        
        self.view.addSubview(illustrationImageView)
        illustrationImageView.translatesAutoresizingMaskIntoConstraints = false
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            // Device is iPad
//            illustrationImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70.0).isActive = true
//        } else {
//            illustrationImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
//        }
        illustrationImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -(ScreenSize.height / 6)).isActive = true
        illustrationImageView.heightAnchor.constraint(equalToConstant: illustrationImageViewHeight).isActive = true
        illustrationImageView.widthAnchor.constraint(equalToConstant: illustrationImageViewWidth).isActive = true
        illustrationImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        
        
        
        
        
        self.view.addSubview(headlineLabel)
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.topAnchor.constraint(equalTo: self.illustrationImageView.bottomAnchor, constant: 20.0).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Device is iPad
            headlineLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: UIScreen.main.bounds.width * 0.15).isActive = true
            headlineLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -1 * UIScreen.main.bounds.width * 0.15).isActive = true
        } else {
            headlineLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40.0).isActive = true
            headlineLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40.0).isActive = true
        }
        
        headlineLabel.text = NSLocalizedString("RatingScreenMenu.headlineLabel.text", comment: "")
//        let front = UIFont(name: "Teko-Bold", size: 45.0)!
//        headlineLabel.setWordsBackground([
//            (NSLocalizedString("RatingScreenMenu.headlineLabel.highlightedWord.text", comment: ""), UIColor(red: 1, green: 0.7882, blue: 0.2863, alpha: 1.0) /* #ffc949 */, font, 10)
//        ], lineHeight: 0)  // First set Line Height to 0
        headlineLabel.setLineHeight(-15)  // Then set Line Height to -15 to ensure the background shape is at the right position (as it's in line 1 this time)
        headlineLabel.textAlignment = .center
        
        
        
        
        
        self.view.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.topAnchor.constraint(equalTo: self.headlineLabel.bottomAnchor, constant: 4.0).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Device is iPad
            subtitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: UIScreen.main.bounds.width * 0.15).isActive = true
            subtitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -1 * UIScreen.main.bounds.width * 0.15).isActive = true
        } else {
            subtitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
            subtitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        }
        
        subtitleLabel.text = NSLocalizedString("RatingScreenMenu.subtitleLabel.text", comment: "")
        
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            subtitleLabel.font = UIFont(name: "Poppins-Regular", size: 22.0)
        } else if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            subtitleLabel.font = UIFont(name: "Poppins-Regular", size: 15.0)
        }
        
        
        
        self.view.addSubview(subtitleLabel2)
        subtitleLabel2.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel2.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 8.0).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Device is iPad
            subtitleLabel2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: UIScreen.main.bounds.width * 0.15).isActive = true
            subtitleLabel2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -1 * UIScreen.main.bounds.width * 0.15).isActive = true
        } else {
            subtitleLabel2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
            subtitleLabel2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        }
        
        subtitleLabel2.text = NSLocalizedString("RatingScreenMenu.subtitleLabel2.text", comment: "")
        
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            subtitleLabel2.font = UIFont(name: "Poppins-Regular", size: 22.0)
        } else if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            subtitleLabel2.font = UIFont(name: "Poppins-Regular", size: 15.0)
        }
        
        
        
        
        
        self.view.addSubview(reviewNowButton)
        reviewNowButton.translatesAutoresizingMaskIntoConstraints = false
        reviewNowButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -14.0).isActive = true
        reviewNowButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            reviewNowButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.85) - 8.0).isActive = true
            reviewNowButton.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
//            reviewNowButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16.0)
        } else {
            reviewNowButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9) - 8.0).isActive = true
            reviewNowButton.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
        }
        
        reviewNowButton.addTarget(self, action: #selector(reviewNowButtonAction), for: .touchUpInside)
        
        // Button Animation
        reviewNowButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        reviewNowButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        reviewNowButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        
        
        
        self.view.addSubview(uploadScreenshotButton)
        uploadScreenshotButton.translatesAutoresizingMaskIntoConstraints = false
        uploadScreenshotButton.bottomAnchor.constraint(equalTo: self.reviewNowButton.topAnchor, constant: -10.0).isActive = true
        uploadScreenshotButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            uploadScreenshotButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.85) - 8.0).isActive = true
            uploadScreenshotButton.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
//            uploadScreenshotButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16.0)
        } else {
            uploadScreenshotButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9) - 8.0).isActive = true
            uploadScreenshotButton.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
        }
        
        uploadScreenshotButton.addTarget(self, action: #selector(uploadScreenshotButtonAction), for: .touchUpInside)
        
        // Button Animation
        uploadScreenshotButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        uploadScreenshotButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        uploadScreenshotButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        uploadScreenshotButton.alpha = 0.5
        uploadScreenshotButton.isUserInteractionEnabled = false
        uploadScreenshotButton.isHidden = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.viewDidBecomeActive()
        
    }
    
    @objc func viewDidBecomeActive() {
        
        print("viewDidBecomeActive")
        
        // User Defaults
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "shouldUserGiveAppStoreReviewToUnlockApp") == nil {
            
            // Do nothing
            
        } else if userDefaults.value(forKey: "shouldUserGiveAppStoreReviewToUnlockApp") as! Bool == false {
            
            // User already did give review
            self.dismiss(animated: true)
            
        }
        
    }
    
    
    @objc func reviewNowButtonAction() {
        
        // Show Custom Review Alert
        DispatchQueue.main.async {
            
            let reviewAlertViewWidth = UIScreen.main.bounds.width * 0.85
            let reviewAlertViewHeight = 300.0
            
            self.reviewAlertView.rateButton.addTarget(self, action: #selector(self.rateButtonAction), for: .touchUpInside)
            self.reviewAlertView.starRatingView.addTarget(self, action: #selector(self.starRatingViewValueChanged), for: .valueChanged)
            self.reviewAlertView.widthAnchor.constraint(equalToConstant: reviewAlertViewWidth).isActive = true
            self.reviewAlertView.heightAnchor.constraint(equalToConstant: reviewAlertViewHeight).isActive = true
            self.malert = Malert(customView: self.reviewAlertView)
            self.malert!.backgroundColor = UIColor.clear
            
            self.present(self.malert!, animated: true)
            
        }
        
    }
    
    
    @objc func uploadScreenshotButtonAction() {
        
        if self.didVisitAppStoreForReview {
            
            if tapUploadScreenshotButtonClicksTracked == false {
                
                tapUploadScreenshotButtonClicksTracked = true
                
                // Update Tracking Data
                DispatchQueue.main.async {
                    
                    let db = Firestore.firestore()
                    let docRefTracking = db.collection("tracking").document("SpecialGiftForReviewNew")
                    docRefTracking.updateData(["tapUploadScreenshotButtonClicks" : FieldValue.increment(Int64(1))])
                    
                }
                
            }
            
            
            self.selectPhoto()
            
        } else {
            
            if tapOpenAppStoreClicksTracked == false {
                
                tapOpenAppStoreClicksTracked = true
                
                // Update Tracking Data
                DispatchQueue.main.async {
                    
                    let db = Firestore.firestore()
                    let docRefTracking = db.collection("tracking").document("SpecialGiftForReviewNew")
                    docRefTracking.updateData(["tapOpenAppStoreClicks" : FieldValue.increment(Int64(1))])
                    
                }
                
            }
            
            
            self.reviewNowButtonAction()
            
        }
        
    }
    
    
    @objc func rateButtonAction() {
        
        uploadScreenshotButton.alpha = 1.0
        uploadScreenshotButton.isUserInteractionEnabled = true
        
        
        // User Defaults
        let userDefaults = UserDefaults.standard
        var didUserGiveRating: Bool = false
        if userDefaults.value(forKey: "didUserGiveRating") != nil {
            didUserGiveRating = userDefaults.value(forKey: "didUserGiveRating") as! Bool
        }
        
        let ratingToString = String(format: "%.0f", self.reviewAlertView.starRatingView.value)
        
        if didUserGiveRating == false {
            
            // Update Database Ratings
            let db = Firestore.firestore()
            let docRefTracking = db.collection("tracking").document("SubmittedRatingViaRatingView")
            docRefTracking.updateData(["submittedRatings" : FieldValue.increment(Int64(1))])
            
            docRefTracking.updateData([ratingToString + "StarRatings" : FieldValue.increment(Int64(1))])  // like "2StarRatings", "4StarRatings" or "5StarRatings"
            
        }
        
        
        userDefaults.setValue(true, forKey: "didUserGiveRating")  // User did give rating successfully
        userDefaults.setValue(false, forKey: "shouldUserGiveAppStoreReviewToUnlockApp")  // When false user did give review
        
        if self.reviewAlertView.starRatingView.value <= 3 {
            
            //userDefaults.setValue(false, forKey: "shouldUserGiveAppStoreReviewToUnlockApp")  // When false user did give review
            
            // Continue App
            self.malert?.dismiss(animated: true, completion: {
                
                self.delay(0.4) {
                    self.dismiss(animated: true)
                }
                
            })
            
            self.dismiss(animated: true)
            
        } else {
            
            //self.addLoadingIndicator()
            
            self.didVisitAppStoreForReview = true
            
            // Redirect to App Store
            DispatchQueue.main.async {
                
                let appId = "6469041230"
                let url = "itms-apps://itunes.apple.com/app/id\(appId)?mt=8&action=write-review"
                
                guard let url = URL(string: url) else {
                    return
                }
                
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            }
            
        }
        
        self.malert?.dismiss(animated: true)
        
    }
    
    
    func selectPhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // print out the image size as a test
        print("image.size")
        print(image.size)
        
        self.addLoadingIndicator()
        
        // Delay of 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Executed after 3 seconds delay")
            
            // User Defaults
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(false, forKey: "shouldUserGiveAppStoreReviewToUnlockApp")  // When false user did give review
            
            self.removeLoadingIndicator()
            self.dismiss(animated: true)
            
        }
        
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    @objc func starRatingViewValueChanged() {
        
        if self.reviewAlertView.starRatingView.value == 0 {
            
            self.reviewAlertView.rateButton.isHidden = true
            
        } else if self.reviewAlertView.starRatingView.value <= 3 {
            
            self.reviewAlertView.rateButton.isHidden = false
            self.reviewAlertView.rateButton.setTitle(NSLocalizedString("ReviewAlertView.rateUs", comment: ""), for: .normal)
            
        } else {
            
            self.reviewAlertView.rateButton.isHidden = false
            self.reviewAlertView.rateButton.setTitle(NSLocalizedString("ReviewAlertView.rateUs", comment: ""), for: .normal)
            
        }
        
    }
    
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        
        sender.touchDownAnimation {}
        
    }
    
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        
        sender.touchUpAnimation {}
        
    }
    
}
