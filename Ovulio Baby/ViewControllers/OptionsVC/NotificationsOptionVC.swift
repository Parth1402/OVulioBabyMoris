//
//  NotificationsOptionVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-28.
//

import UIKit

class NotificationsOptionVC: UIViewController {

    var customNavBarView: CustomNavigationBar?
    let notifictionData = [["title": "NotificationsOptionVC.PeriodStarting.headlineLabel.text"~,
                            "subtitle": "NotificationsOptionVC.PeriodStarting.headlineDescriptionLabel.text"~],
                           ["title": "NotificationsOptionVC.FavorableDay.headlineLabel.text"~,
                                                   "subtitle": "NotificationsOptionVC.PeriodStarting.headlineDescriptionLabel.text"~],
                           ["title": "NotificationsOptionVC.GenderNotification.headlineLabel.text"~,
                                                   "subtitle": "NotificationsOptionVC.PeriodStarting.headlineDescriptionLabel.text"~]]
    
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
            titleString: "NotificationsOptionVC.headlineLabel.text"~
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
        tableView.register(NotificationOptionsTBLCell.self, forCellReuseIdentifier: "NotificationOptionsTBLCell")
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
extension NotificationsOptionVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifictionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationOptionsTBLCell", for: indexPath) as! NotificationOptionsTBLCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
            cell.titleLabel.text = notifictionData[indexPath.row]["title"]
            cell.subTitleLabel.text = notifictionData[indexPath.row]["subtitle"]
            cell.setupCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
