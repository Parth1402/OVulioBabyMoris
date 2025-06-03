//
//  OurExpertsOptionPageVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-28.
//

import UIKit
import Pageboy

class OurExpertsOptionPageVC: PageboyViewController, PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    
    var customNavBarView: CustomNavigationBar?
    let pageControl = UIPageControl()
    var isFromSalesPage = false
    
    private lazy var viewControllers: [UIViewController] = [
        OurExpertsDetailsVC(isFromSalesPage: isFromSalesPage),
//        OurExpertsDetailsVC(isFromSalesPage: isFromSalesPage),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isFromSalesPage {
            setUpBackground()
            setUpNavigationBar()
        } else {
            self.view.backgroundColor = .clear
        }
        setUpPageVCs()
    }
    
    func setUpBackground() {
        
        let backgroundImage = UIImageView(frame: ScreenSize.bounds)
        backgroundImage.backgroundColor = UIColor(hexString: "FFF2F2")
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
        
    }
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "optionScreenBackButtonIMG"),
            titleString: "OurExpertsOptionPageVC.headlineLabel.text"~
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
    
    func setUpPageVCs() {
        if viewControllers.count == 1 {
            self.pageControl.isHidden = true
            self.isScrollEnabled = false
        }
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
            self.pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
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
    }
    
}
