//
//  FirstOnBoardingPageVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-24.
//

import UIKit
import Pageboy

class FirstOnBoardingPageVC: PageboyViewController, PageboyViewControllerDataSource, PageboyViewControllerDelegate {

    let nextButton = CommonView.getCommonButton(title: "FirstOnBoardingPageVC.Button.Next.headlineLabel.text"~, font: .mymediumSystemFont(ofSize: 16), cornerRadius: 20)
    let skipButton = CommonView.getCommonButton(title: "FirstOnBoardingPageVC.Button.Skip.headlineLabel.text"~, font: .systemFont(ofSize: 16), titleColor: appColor, backgroundColor: .clear)
    let pageControl = UIPageControl()
    private lazy var viewControllers: [UIViewController] = [
        //WithEaseOnBoardingVC(),
        TrackFertilityOnBoardingVC(),
        InfluenceGenderOnBoardingVC(),
        DevelopedExpertOnBoardingVC(),
        OurReferencesOnBoardingVC(),
    ]
    
    var didScrollToPageHapticFeedback: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        nextButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        nextButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        nextButton.addTarget(self, action: #selector(scrollToNextPage(_:)), for: .touchUpInside)
        self.view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: bottomBackgroundImageView.leadingAnchor, constant: DeviceSize.onbordingButtonLeftRightPadding),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -((ScreenSize.height * 0.25) / 8)),
            nextButton.trailingAnchor.constraint(equalTo: bottomBackgroundImageView.trailingAnchor, constant: -DeviceSize.onbordingButtonLeftRightPadding),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        skipButton.addTarget(self, action: #selector(skipTheStep(_:)), for: .touchUpInside)
        self.view.addSubview(skipButton)
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: bottomBackgroundImageView.leadingAnchor, constant: DeviceSize.onbordingButtonLeftRightPadding),
            skipButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -8),
            skipButton.trailingAnchor.constraint(equalTo: bottomBackgroundImageView.trailingAnchor, constant: -DeviceSize.onbordingButtonLeftRightPadding),
            skipButton.topAnchor.constraint(greaterThanOrEqualTo: bottomBackgroundImageView.topAnchor, constant: 10)
        ])
        
        self.pageControl.numberOfPages = viewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = pitchOnboradingAppColor
        self.pageControl.currentPageIndicatorTintColor = appColor
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.sizeToFit()
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControl)
        self.view.bringSubviewToFront(pageControl)
        NSLayoutConstraint.activate([
            self.pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.pageControl.bottomAnchor.constraint(equalTo: bottomBackgroundImageView.topAnchor, constant: 15),
            self.pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            self.pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
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
        
        if didScrollToPageHapticFeedback == true {
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        } else {
            
            didScrollToPageHapticFeedback = true
            
        }
        
    }
    
}

// MARK: Actions
extension FirstOnBoardingPageVC {
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }

    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }

    @objc func scrollToNextPage(_ sender: UIButton) {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        didScrollToPageHapticFeedback = false
        
        if currentIndex == 3 {
            let vc = ReceiveNotificationsOnBoardingVC()
            vc.modalPresentationStyle = .currentContext
            self.present(vc, animated: true)
            return
        }
        
        self.nextButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
            self.nextButton.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: {
                self.nextButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) {_ in 
                self.nextButton.isUserInteractionEnabled = true
                self.scrollToPage(.next, animated: true)
            }
        }
        
    }
    
    @objc func skipTheStep(_ sender: UIButton) {
        
        skipButton.showAnimation(isForError: true) {
            let vc = ReceiveNotificationsOnBoardingVC()
            vc.modalPresentationStyle = .currentContext
            self.present(vc, animated: true)
        }
        
    }
    
}
