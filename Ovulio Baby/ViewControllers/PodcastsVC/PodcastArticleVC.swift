//
//  PodcastArticleVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2025-03-08.
//

import UIKit

class PodcastArticleVC: UIViewController {
    
    var podcastArticleVCBackTapped: (() -> Void)?
    
    override func viewDidLoad() {
        self.view.setUpBackground()
        setupUI()
    }
    
    private func setupUI() {
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "closeButtonNotEnoughData"), for: .normal)
        backButton.frame = CGRect(x: view.frame.width - 50, y: 20, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        let illustrationImageView = UIImageView(image: UIImage(named: "podcastArticleimage"))
        illustrationImageView.contentMode = .scaleAspectFit
        view.addSubview(illustrationImageView)
        illustrationImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            illustrationImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            illustrationImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            illustrationImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        ])
        
        let headingLabel = CommonView.getCommonLabel(text: "Relaxation & Conception.\nWhy It Matters?"~, font: UIFont.boldSystemFont(ofSize: 24), lines: 2, alignment: .left)
        view.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headingLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            headingLabel.topAnchor.constraint(equalTo: illustrationImageView.bottomAnchor, constant: -50),
            headingLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        ])
        
        if ProfileDataManager.shared.hasSeenPodcastArticle {
            let descriptionTextView = UITextView()
            descriptionTextView.text = "PodcastArticleVC.subtitleLabel.text"~
            descriptionTextView.font = .mySystemFont(ofSize: 14)
            descriptionTextView.textColor = appColor
            descriptionTextView.isEditable = false
            descriptionTextView.showsVerticalScrollIndicator = false
            descriptionTextView.isScrollEnabled = true
            descriptionTextView.backgroundColor = .clear
            descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionTextView)
            NSLayoutConstraint.activate([
                descriptionTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                descriptionTextView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 16),
                descriptionTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                descriptionTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
            ])
        } else {
            let ctaButton = CommonView.getCommonButton(title: "SqueezLickSuckGame.letsGoButton.title"~, cornerRadius: 25)
            ctaButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(ctaButton)
            NSLayoutConstraint.activate([
                ctaButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                ctaButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
                ctaButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                ctaButton.heightAnchor.constraint(equalToConstant: 50)
            ])
            ctaButton.addTarget(self, action: #selector(ctaButtonTapped), for: .touchUpInside)
            
            
            let descriptionTextView = UITextView()
            descriptionTextView.text = "PodcastArticleVC.subtitleLabel.text"~
            descriptionTextView.font = .mySystemFont(ofSize: 14)
            descriptionTextView.textColor = appColor
            descriptionTextView.isEditable = false
            descriptionTextView.showsVerticalScrollIndicator = false
            descriptionTextView.isScrollEnabled = true
            descriptionTextView.backgroundColor = .clear
            descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionTextView)
            NSLayoutConstraint.activate([
                descriptionTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                descriptionTextView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 16),
                descriptionTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                descriptionTextView.bottomAnchor.constraint(equalTo: ctaButton.topAnchor, constant: -20)
            ])
            
        }
        
    }
    
    @objc private func backButtonTapped() {
        if let action = podcastArticleVCBackTapped {
            action()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func ctaButtonTapped() {
        
        if !isUserProMember() {
            
            let vc = SalesVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        } else {
            
            // User is Pro Member
            if let action = podcastArticleVCBackTapped {
                ProfileDataManager.shared.updateHasSeenPodcastArticle(true)
                action()
            }
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
}
