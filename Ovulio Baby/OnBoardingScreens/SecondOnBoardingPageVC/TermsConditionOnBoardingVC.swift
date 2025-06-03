//
//  TermsConditionOnBoardingVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-26.
//

import UIKit

class TermsConditionOnBoardingVC: UIViewController {
    
    let backgroundShapeImageView: UIImageView = {
        
        let imageViewBackgroundShape = UIImageView()
        imageViewBackgroundShape.backgroundColor = UIColor.clear
        imageViewBackgroundShape.contentMode = .scaleAspectFill
        imageViewBackgroundShape.clipsToBounds = true
        
        return imageViewBackgroundShape
        
    }()
    
    var scrollView = UIScrollView()
    var scrollContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headlineLabel: UILabel = {
        let labelHeadline = UILabel()
        labelHeadline.backgroundColor = UIColor.clear
        labelHeadline.textColor = appColor
        labelHeadline.textAlignment = .left
        labelHeadline.numberOfLines = 0
        return labelHeadline
    }()
    
    let textView = UITextView()
    
    let agreementLabel: UILabel = {
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = .systemFont(ofSize: 14)
        labelText.textColor = appColor
        labelText.textAlignment = .left
        labelText.adjustsFontSizeToFitWidth = true
        labelText.numberOfLines = 0
        labelText.lineBreakMode = .byWordWrapping
        return labelText
    }()
    
    let agreementConfirmButton: UIButton = {
        
        let buttonConfirm = UIButton()
        buttonConfirm.setImage(UIImage(named: "placeUncheckedImage"), for: .normal)
        buttonConfirm.backgroundColor = .white
        return buttonConfirm
        
    }()
    
    var agreementConfirmButtonClicked: Bool = false
    
    var isAgreementChecked: ((_ isChecked: Bool) -> Void)!
    
    init(isAgreementChecked: @escaping ((_ isChecked: Bool) -> Void)) {
        super.init(nibName: nil, bundle: nil)
        self.isAgreementChecked = isAgreementChecked
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(backgroundShapeImageView)
        backgroundShapeImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundShapeImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        backgroundShapeImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        backgroundShapeImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        backgroundShapeImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        backgroundShapeImageView.alpha = 1.0
            backgroundShapeImageView.image = UIImage(named: "homeScreenBackground")
        
        let leftAnchor = ScreenSize.width * 0.04
        let leftAnchorForScrollView = DeviceSize.isiPadDevice ? ScreenSize.width * 0.2 : ScreenSize.width * 0.04
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            leftAnchor = UIScreen.main.bounds.width * 0.175 + 20.0
//        }
        
        self.view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: (ScreenSize.height * 0.05) + 20, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 55 + (DeviceSize.onbordingContentTopPadding - (DeviceSize.isiPadDevice ? 10 : 25))).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(ScreenSize.height * 0.20)).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: leftAnchorForScrollView).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 00.0).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -(leftAnchorForScrollView * 2)).isActive = true
        
        self.scrollView.addSubview(scrollContainerView)
        scrollContainerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20.0).isActive = true
        scrollContainerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0.0).isActive = true
        scrollContainerView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 0.0).isActive = true
        scrollContainerView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: 0.0).isActive = true
        scrollContainerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -3.0).isActive = true
        
        self.scrollContainerView.addSubview(headlineLabel)
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.topAnchor.constraint(equalTo: self.scrollContainerView.topAnchor, constant: 20.0).isActive = true
        headlineLabel.leadingAnchor.constraint(equalTo: self.scrollContainerView.leadingAnchor, constant: leftAnchor + 5).isActive = true
        headlineLabel.trailingAnchor.constraint(equalTo: self.scrollContainerView.trailingAnchor, constant: -leftAnchor).isActive = true
        headlineLabel.font = .boldSystemFont(ofSize: 24)
        headlineLabel.text = "TermsConditionOnBoardingVC.headlineLabel.text"~
        headlineLabel.sizeToFit()
        
        self.scrollContainerView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.headlineLabel.bottomAnchor, constant: 10.0).isActive = true
        textView.leftAnchor.constraint(equalTo: self.scrollContainerView.leftAnchor, constant: leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.scrollContainerView.rightAnchor, constant: -leftAnchor).isActive = true
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = UIColor.clear
        textView.font = .systemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14)
        textView.textColor = appColor
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        textView.text = "TermsConditionOnBoardingVC.headlineDescriptionLabel.text"~
        textView.sizeToFit()
        
        self.scrollContainerView.addSubview(agreementLabel)
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        agreementLabel.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 0).isActive = true
        agreementLabel.bottomAnchor.constraint(equalTo: self.scrollContainerView.bottomAnchor, constant: -(leftAnchor)).isActive = true
        agreementLabel.leftAnchor.constraint(equalTo: self.scrollContainerView.leftAnchor, constant: leftAnchor + 30.0 + 8.0).isActive = true
        agreementLabel.rightAnchor.constraint(equalTo: self.scrollContainerView.rightAnchor, constant: -1 * leftAnchor).isActive = true
        agreementLabel.text = "TermsConditionOnBoardingVC.agreementLabel.text"~
        
        
        let termsAndConditions = "TermsConditionOnBoardingVC.agreementLabel.attribute.termsAndConditions"~
        let privacyPolicy = "TermsConditionOnBoardingVC.agreementLabel.attribute.privacyPolicy"~
        let disclaimer = "TermsConditionOnBoardingVC.agreementLabel.attribute.disclaimer"~
        
        agreementLabel.isUserInteractionEnabled = true
        
        agreementLabel.attributedText = attributedTextMakeBoldAndUnderlined(withString: "TermsConditionOnBoardingVC.agreementLabel.text"~, boldString: [termsAndConditions, privacyPolicy, disclaimer], fontSize: 16.0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
        agreementLabel.addGestureRecognizer(tap)
        agreementLabel.sizeToFit()
        
        self.scrollContainerView.addSubview(agreementConfirmButton)
        agreementConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        agreementConfirmButton.leftAnchor.constraint(equalTo: self.scrollContainerView.leftAnchor, constant: leftAnchor + 2.0).isActive = true
        agreementConfirmButton.centerYAnchor.constraint(equalTo: self.agreementLabel.centerYAnchor, constant: 0.0).isActive = true
        agreementConfirmButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        agreementConfirmButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        agreementConfirmButton.addTarget(self, action: #selector(agreementConfirmButtonAction), for: .touchUpInside)
        
    }
    
    
    @objc func agreementConfirmButtonAction() {
        
        if agreementConfirmButtonClicked == false {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            agreementConfirmButton.setImage(UIImage(named: "placeCheckedImage"), for: .normal)
            agreementConfirmButton.backgroundColor = .clear
            agreementConfirmButtonClicked = true
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            agreementConfirmButton.setImage(UIImage(named: "placeUncheckedImage"), for: .normal)
            agreementConfirmButton.backgroundColor = .clear
            agreementConfirmButtonClicked = false
        }
        
        if let action = isAgreementChecked {
            action(agreementConfirmButtonClicked)
        }
        
    }
    
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }
    
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    
    func attributedTextMakeBoldAndUnderlined(withString string: String, boldString: [String], fontSize: CGFloat) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: appColor!, NSAttributedString.Key.foregroundColor: appColor!]
        
        for i in 0...boldString.count-1 {
            let range = (string as NSString).range(of: boldString[i])
            attributedString.addAttributes(boldFontAttribute, range: range)
        }
        return attributedString
    }
    
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        
        let termText = "TermsConditionOnBoardingVC.agreementLabel.text"~
        let termsAndConditions = "TermsConditionOnBoardingVC.agreementLabel.attribute.termsAndConditions"~
        let privacyPolicy = "TermsConditionOnBoardingVC.agreementLabel.attribute.privacyPolicy"~
        let disclaimer = "TermsConditionOnBoardingVC.agreementLabel.attribute.disclaimer_tappable"~
        
        self.agreementLabel.sizeToFit()
        let termLabel = self.agreementLabel
        let termString = termText as NSString
        let termsAndConditionsRange = termString.range(of: termsAndConditions)
        let privacyPolicyRange = termString.range(of: privacyPolicy)
        let disclaimerRange = termString.range(of: disclaimer)
        
        let tapLocation = gesture.location(in: termLabel)
        let index = termLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        if checkRange(termsAndConditionsRange, contain: index) == true {
            print("termsAndConditions")
            if let url = URL(string: "https://www.ovulio-baby.com/app-terms-conditions") {
                UIApplication.shared.open(url)
            }
            return
        }
        
        if checkRange(privacyPolicyRange, contain: index) == true {
            print("privacyPolicyRange")
            if let url = URL(string: "https://www.ovulio-baby.com/app-privacy-policy") {
                UIApplication.shared.open(url)
            }
            return
        }
        
        if checkRange(disclaimerRange, contain: index) == true {
            print("disclaimerRange")
            if let url = URL(string: "https://www.ovulio-baby.com/app-disclaimer") {
                UIApplication.shared.open(url)
            }
            return
        }
    }
    
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
}
