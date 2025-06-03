//
//  SecondOnBoardingPageVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-25.
//

import UIKit
import Pageboy

class CustomPageControl: UIPageControl {
    var customPageControlColor: UIColor = .gray
    var customCurrentPageColor: UIColor = .blue

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        for view in subviews {
            view.alpha = 0.0
        }

        if numberOfPages > 1 {
            let width: CGFloat = 22.0
            let height: CGFloat = 2.0
            let spacing: CGFloat = 10.0
            let totalWidth = width * CGFloat(numberOfPages) + spacing * CGFloat(max(0, numberOfPages - 1))
            var x = (rect.size.width - totalWidth) / 2.0

            for i in 0..<numberOfPages {
                let circleRect = CGRect(x: x, y: (rect.size.height - height) / 2.0, width: width, height: height)
                let circlePath = UIBezierPath(roundedRect: circleRect, cornerRadius: height / 2.0)
                let circleColor = (i == currentPage) ? customCurrentPageColor : customPageControlColor
                circleColor.setFill()
                circlePath.fill()
                x += width + spacing
            }
        }
    }
}

class SecondOnBoardingPageVC: PageboyViewController, PageboyViewControllerDataSource, PageboyViewControllerDelegate {

    let submitButton = CommonView.getCommonButton(title: "UIAlertController.continueButton"~, font: .mymediumSystemFont(ofSize: 16), cornerRadius: 20)
    let skipButton = CommonView.getCommonButton(title: "SecondOnBoardingPageVC.Button.SkipStep.headlineLabel.text"~, font: .systemFont(ofSize: 16), titleColor: appColor, backgroundColor: .clear)
    let submitButtonDidableView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var termsConditionOnBoardingVC = TermsConditionOnBoardingVC(isAgreementChecked: { isChecked in
        self.isAgreementChecked = isChecked
    })
    var isAgreementChecked = false
    let pageControl = CustomPageControl()
    private lazy var viewControllers: [UIViewController] = [
//        WhoPlayingOnBoardingVC(isFieldChanged: {
//            if ProfileDataBeforeSaving.isMotherNameChanged ||
//                ProfileDataBeforeSaving.isFatherNameChanged {
//                self.submitButtonDidableView.isHidden = true
//            }else{
//                self.submitButtonDidableView.isHidden = false
//            }
//        }),
        MentruationCycleOnBoardingVC(isFieldChanged: {
            if ProfileDataBeforeSaving.isLastPeriodDateChanged ||
                ProfileDataBeforeSaving.isCycleLengthChanged {
                self.submitButtonDidableView.isHidden = true
            }else{
                self.submitButtonDidableView.isHidden = false
            }
        }),
        BirthDateOnBoardingVC(isFieldChanged: {
            if ProfileDataBeforeSaving.isMotherBirthdateChanged ||
                ProfileDataBeforeSaving.isFatherBirthDateChanged {
                self.submitButtonDidableView.isHidden = true
            }else{
                self.submitButtonDidableView.isHidden = false
            }
        }),
        GenderSelectionOnBoradingVC(isFieldChanged: {
            if ProfileDataBeforeSaving.isGenderChangeed {
                self.submitButtonDidableView.isHidden = true
            }else{
                self.submitButtonDidableView.isHidden = false
            }
        }),
        termsConditionOnBoardingVC
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isScrollEnabled = false
        self.view.setUpBackground()
        let bottomBackgroundImageView = CommonView.getCommonImageView(image: "splashScreenInBackground")
        bottomBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBackgroundImageView)
        NSLayoutConstraint.activate([
            bottomBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
        
        // Button Animation
        submitButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        submitButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        submitButton.addTarget(self, action: #selector(scrollToNextPage(_:)), for: .touchUpInside)
        self.view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: bottomBackgroundImageView.leadingAnchor, constant: DeviceSize.onbordingButtonLeftRightPadding),
            submitButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -((ScreenSize.height * 0.25) / 8)),
            submitButton.trailingAnchor.constraint(equalTo: bottomBackgroundImageView.trailingAnchor, constant: -DeviceSize.onbordingButtonLeftRightPadding),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(submitButtonDidableView)
        submitButtonDidableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButtonDidableView.topAnchor.constraint(equalTo: submitButton.topAnchor),
            submitButtonDidableView.leadingAnchor.constraint(equalTo: submitButton.leadingAnchor),
            submitButtonDidableView.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor),
            submitButtonDidableView.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor)
        ])
        
        skipButton.addTarget(self, action: #selector(skipTheStep(_:)), for: .touchUpInside)
        self.view.addSubview(skipButton)
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: bottomBackgroundImageView.leadingAnchor, constant: DeviceSize.onbordingButtonLeftRightPadding),
            skipButton.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -8),
            skipButton.trailingAnchor.constraint(equalTo: bottomBackgroundImageView.trailingAnchor, constant: -DeviceSize.onbordingButtonLeftRightPadding),
            skipButton.topAnchor.constraint(greaterThanOrEqualTo: bottomBackgroundImageView.topAnchor, constant: 10)
        ])
        
        pageControl.numberOfPages = viewControllers.count
        pageControl.currentPage = 0
        pageControl.customPageControlColor = lightAppColor!
        pageControl.customCurrentPageColor = appColor!
        pageControl.backgroundColor = .clear
        pageControl.isUserInteractionEnabled = false
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControl)
        self.view.bringSubviewToFront(pageControl)
        NSLayoutConstraint.activate([
            self.pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (DeviceSize.onbordingContentTopPadding - (DeviceSize.isiPadDevice ? 20 : 20))),
            self.pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        self.dataSource = self
        self.delegate = self
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func pageboyViewController(_ pageboyViewController: Pageboy.PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: Pageboy.PageboyViewController.PageIndex) {
    }
    
    func pageboyViewController(_ pageboyViewController: Pageboy.PageboyViewController, didScrollTo position: CGPoint, direction: Pageboy.PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: Pageboy.PageboyViewController, willScrollToPageAt index: Pageboy.PageboyViewController.PageIndex, direction: Pageboy.PageboyViewController.NavigationDirection, animated: Bool) {
    }
    
    func pageboyViewController(_ pageboyViewController: Pageboy.PageboyViewController, didScrollToPageAt index: Pageboy.PageboyViewController.PageIndex, direction: Pageboy.PageboyViewController.NavigationDirection, animated: Bool) {
        self.pageControl.currentPage = index
        pageControl.setNeedsDisplay()
        
        if index == viewControllers.count - 1 {
            submitButton.setTitle("SecondOnBoardingPageVC.Button.LetsGo.headlineLabel.text"~, for: .normal)
            skipButton.isHidden = true
        } else {
            submitButton.setTitle("UIAlertController.continueButton"~, for: .normal)
            skipButton.isHidden = false
        }
        
        switch index {
//        case 0:
//            if ProfileDataBeforeSaving.isMotherNameChanged ||
//                ProfileDataBeforeSaving.isFatherNameChanged {
//                self.submitButtonDidableView.isHidden = true
//            }else{
//                self.submitButtonDidableView.isHidden = false
//            }
//            break
        case 0:
            if ProfileDataBeforeSaving.isLastPeriodDateChanged ||
                ProfileDataBeforeSaving.isCycleLengthChanged {
                self.submitButtonDidableView.isHidden = true
            }else{
                self.submitButtonDidableView.isHidden = false
            }
            break
        case 1:
            if ProfileDataBeforeSaving.isMotherBirthdateChanged ||
                ProfileDataBeforeSaving.isFatherBirthDateChanged {
                self.submitButtonDidableView.isHidden = true
            }else{
                self.submitButtonDidableView.isHidden = false
            }
            break
        case 2:
            if ProfileDataBeforeSaving.isGenderChangeed {
                self.submitButtonDidableView.isHidden = true
            }else{
                self.submitButtonDidableView.isHidden = false
            }
            break
        default:
            self.submitButtonDidableView.isHidden = true
            break
        }
    }

}

// MARK: Actions
extension SecondOnBoardingPageVC {
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }

    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    @objc func scrollToNextPage(_ sender: UIButton) {
        self.submitButton.showAnimation {
            if self.submitButton.titleLabel?.text == "SecondOnBoardingPageVC.Button.LetsGo.headlineLabel.text"~ {
                
                if !self.isAgreementChecked {
                    // Alert
                    self.showAlert(title: NSLocalizedString("TermsConditionOnBoardingVC.alert.previewTerms.title", comment: ""), message: NSLocalizedString("TermsConditionOnBoardingVC.alert.previewTerms.message", comment: ""))
                    return
                }
                if ProfileDataBeforeSaving.motherName != nil { ProfileDataManager.shared.updateMotherName(ProfileDataBeforeSaving.motherName!)
                }
                if ProfileDataBeforeSaving.fatherName != nil { ProfileDataManager.shared.updateFatherName(ProfileDataBeforeSaving.fatherName!)
                }
                ProfileDataManager.shared.updateGender(to: ProfileDataBeforeSaving.selectedGender)
                if ProfileDataBeforeSaving.lastPeriodDate != nil { ProfileDataManager.shared.updateLastPeriodDate(ProfileDataBeforeSaving.lastPeriodDate!)
                }
                if ProfileDataBeforeSaving.cycleLength != nil { ProfileDataManager.shared.updateCycleLength(ProfileDataBeforeSaving.cycleLength!)
                }
                if ProfileDataBeforeSaving.motherBirthdate != nil { ProfileDataManager.shared.updateMotherBirthdate(ProfileDataBeforeSaving.motherBirthdate)
                }
                if ProfileDataBeforeSaving.fatherBirthdate != nil { ProfileDataManager.shared.updateFatherBirthdate(ProfileDataBeforeSaving.fatherBirthdate)
                }
//                if ProfileDataBeforeSaving.isGenderChangeed {
//                    if let delegate = self.genderUpdationProtocolDelegate {
//                        delegate.isGenderChanged()
//                    }
//                }
                ProfileDataBeforeSaving.isMotherNameChanged = false
                ProfileDataBeforeSaving.isFatherNameChanged = false
                ProfileDataBeforeSaving.isGenderChangeed = false
                ProfileDataBeforeSaving.isLastPeriodDateChanged = false
                ProfileDataBeforeSaving.isCycleLengthChanged = false
                ProfileDataBeforeSaving.isMotherBirthdateChanged = false
                ProfileDataBeforeSaving.isFatherBirthDateChanged = false
                ProfileDataManager.shared.updateHasCompletedOnboarding(true)
                let vc = HomeViewController()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
            }else{
                self.scrollToPage(.next, animated: true)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Redeem Coupon Code
        let actionOne = UIAlertAction(title: "OK", style: .default) { (action) in
            
            DispatchQueue.main.async {
                let bottomOffset = CGPoint(x: 0, y: (self.termsConditionOnBoardingVC.scrollView.contentSize.height - self.termsConditionOnBoardingVC.scrollView.bounds.size.height) + ((ScreenSize.height * 0.05) + 20))
                self.termsConditionOnBoardingVC.scrollView.setContentOffset(bottomOffset, animated: true)
            }
            
        }
        
        // Add action to action sheet
        alert.addAction(actionOne)
        
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = appColor
        self.present(alert, animated: true)
        
    }
    
    @objc func skipTheStep(_ sender: UIButton) {
        skipButton.showAnimation(isForError: true) {
            self.scrollToPage(.next, animated: true)
        }
    }
}
