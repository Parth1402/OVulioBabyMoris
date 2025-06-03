//
//  OurExpertsDetailsVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-28.
//

import UIKit

class OurExpertsDetailsVC: UIViewController {

    var isFromSalesPage = false
    
    init(isFromSalesPage: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isFromSalesPage = isFromSalesPage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftRightPadding = 20.0
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (DeviceSize.isiPadDevice ? ((ScreenSize.width * 0.32) * 0.5) : leftRightPadding)),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44 + 15),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightPadding),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: (DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.32) : -(leftRightPadding * 2))),
        ])
        
        let scrollContentView = CommonView.getViewWithShadowAndRadius(cornerRadius: 25)
        scrollView.addSubview(scrollContentView)
        NSLayoutConstraint.activate([
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        let expertImageView = CommonView.getCommonImageView(image: "ExpertsUsmanImage")
        expertImageView.contentMode = .scaleAspectFit
        scrollContentView.addSubview(expertImageView)
        NSLayoutConstraint.activate([
            expertImageView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 30),
            expertImageView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            expertImageView.widthAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 200 : 156),
            expertImageView.heightAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 200 : 156),
        ])
        
        let expertNameLabel = CommonView.getCommonLabel(text: NSLocalizedString("OurExpertsDetailsVC.expertNameLabel.text", comment: ""), font: .boldSystemFont(ofSize: DeviceSize.isiPadDevice ? 20 : 16), lines: 0)
        if !isFromSalesPage {
            scrollContentView.addSubview(expertNameLabel)
            NSLayoutConstraint.activate([
                expertNameLabel.topAnchor.constraint(equalTo: expertImageView.bottomAnchor, constant: 20),
                expertNameLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: leftRightPadding),
                expertNameLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: leftRightPadding),
            ])
        }
        
        let expertReviewLabel = CommonView.getCommonLabel(text: NSLocalizedString("OurExpertsDetailsVC.expertReviewLabel.text", comment: ""), textColor: lightAppColor, font: .italicSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14), lines: 0)
        scrollContentView.addSubview(expertReviewLabel)
        NSLayoutConstraint.activate([
            expertReviewLabel.topAnchor.constraint(equalTo: (!isFromSalesPage ? expertNameLabel : expertImageView).bottomAnchor, constant: 15),
            expertReviewLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: leftRightPadding),
            expertReviewLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -leftRightPadding),
        ])
        
        if !isFromSalesPage {
            let expertInfoLabel = CommonView.getCommonLabel(text: NSLocalizedString("OurExpertsDetailsVC.expertInfoLabel.text", comment: ""), font: .systemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 14), lines: 0)
            scrollContentView.addSubview(expertInfoLabel)
            NSLayoutConstraint.activate([
                expertInfoLabel.topAnchor.constraint(equalTo: expertReviewLabel.bottomAnchor, constant: 15),
                expertInfoLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: leftRightPadding),
                expertInfoLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -leftRightPadding),
                expertInfoLabel.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20)
            ])
        }else{
            scrollContentView.addSubview(expertNameLabel)
            NSLayoutConstraint.activate([
                expertNameLabel.topAnchor.constraint(equalTo: expertReviewLabel.bottomAnchor, constant: 20),
                expertNameLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: leftRightPadding),
                expertNameLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: leftRightPadding),
                expertNameLabel.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20)
            ])
            self.view.backgroundColor = .clear
            scrollContentView.backgroundColor = UIColor(hexString: "FFF2F2") ?? .white
        }
        
        
    }

}
