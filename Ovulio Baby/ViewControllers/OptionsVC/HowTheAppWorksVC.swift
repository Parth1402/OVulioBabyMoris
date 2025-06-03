//
//  HowTheAppWorksVC.swift
//  Ovulio Baby
//
//  Created by Maurice Wirth on 23.12.23.
//

import UIKit
import Pageboy

class HowTheAppWorksVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpNavigationBar()
        setupTextView()
        
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
            titleString: "HowTheAppWorksVC.headlineLabel.text"~
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
    
    
    func setupTextView() {
        
        // Add the text view to the view hierarchy
        view.addSubview(textView)
        
        // Configure the text view properties
        textView.backgroundColor = UIColor.clear // Set background to transparent
        textView.text = "HowTheAppWorksVC.textView.text"~ // Set your text here
        textView.backgroundColor = UIColor.clear
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = appColor
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        textView.sizeToFit()
        
        // Enable interaction with links
        textView.isEditable = false  // Make it non-editable if it's just for display
        textView.isScrollEnabled = true  // Enable scrolling
        
        if RCValues.sharedInstance.bool(forKey: .custom_review_alert_enabled_2_8_0) == false {
            
            // Create an attributed string
            let normalTextAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14), // Change font and size
                    .foregroundColor: appColor, // Change text color
                    // Add other attributes as needed
                ]
            let normalText = NSAttributedString(string: "HowTheAppWorksVC.textView.text"~, attributes: normalTextAttributes)
            let attributedString = NSMutableAttributedString(attributedString: normalText)
            
            // Add a clickable link
            let linkText = NSAttributedString(string: "Dr. Shettles' Method \n", attributes: [NSAttributedString.Key.link: URL(string: "https://www.amazon.de/-/en/Landrum-B-Shettles-ebook/dp/B004KABDJI")!])
            attributedString.append(linkText)
            
            let linkText1 = NSAttributedString(string: "Dr. Farhud’s Study \n", attributes: [NSAttributedString.Key.link: URL(string: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9546797/pdf/IJPH-51-1886.pdf")!])
            attributedString.append(linkText1)
            
            let linkText2 = NSAttributedString(string: "Dr. Karen Kind Study \n", attributes: [NSAttributedString.Key.link: URL(string: "https://www.rbmojournal.com/article/S1472-6483(10)61178-9/pdf")!])
            attributedString.append(linkText2)
            
            // Set the attributed text to the text view
            textView.attributedText = attributedString
            
            // Edit interaction with links
            textView.isSelectable = true
            textView.delegate = self
            
            textView.linkTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                           NSAttributedString.Key.foregroundColor: appColor,
                                           NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            
        }
        
        
        // Disable autoresizing mask translation into constraints
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftAnchor = UIScreen.main.bounds.width * 0.04
        
        // Set constraints programmatically
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44 + 15),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leftAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -leftAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
}


extension HowTheAppWorksVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // Perform any custom action with the URL
        // Return false if you handle the link tap yourself, true to allow default handling
        return true
    }
    
}
