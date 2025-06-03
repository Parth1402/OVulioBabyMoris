//
//  LegalOptionVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-27.
//

import UIKit

class LegalOptionVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    
    let tableData = ["LegalOptionVC.LegalNotice.headlineLabel.text"~,
                     "LegalOptionVC.PrivacyPolicy.headlineLabel.text"~,
                     "LegalOptionVC.TermsandConditions.headlineLabel.text"~,
                     "LegalOptionVC.Disclaimer.headlineLabel.text"~,
                     "LegalOptionVC.Attribution.headlineLabel.text"~,
                     "LegalOptionVC.TermsOfUse.headlineLabel.text"~]
    
    // Create a UITableView
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpNavigationBar()
        addTableViewContent()
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
            titleString: "LegalOptionVC.headlineLabel.text"~
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
    
    func addTableViewContent() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(OptionsTBLCell.self, forCellReuseIdentifier: "OptionsTBLCell")
        view.addSubview(tableView)
        
        if let customNavBarView = customNavBarView {
            tableView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        }else{
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension LegalOptionVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTBLCell", for: indexPath) as! OptionsTBLCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
            cell.titleLabel.text = tableData[indexPath.row]
            cell.setupCell()
        
        if indexPath.row == 4 {
            cell.isHidden = true
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 4 {
            return 0.0
        }
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        // Feedback Generator
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        switch indexPath.row {
        case 0:
            if let url = URL(string: "https://www.ovulio-baby.com/legal-notice") {
                UIApplication.shared.open(url)
            }
            break
        case 1:
            if let url = URL(string: "https://www.ovulio-baby.com/app-privacy-policy") {
                UIApplication.shared.open(url)
            }
            break
        case 2:
            if let url = URL(string: "https://www.ovulio-baby.com/app-terms-conditions") {
                UIApplication.shared.open(url)
            }
            break
        case 3:
            if let url = URL(string: "https://www.ovulio-baby.com/app-disclaimer") {
                UIApplication.shared.open(url)
            }
            break
        case 4:
            break
        case 5:
            if let url = URL(string: "https://www.app-privacy-policy.com/live.php?token=vtjM8zU3d37bojAhERuhhtcC1KGRfiUh") {
                UIApplication.shared.open(url)
            }
            break
        default:
            break
        }
        
    }
}
