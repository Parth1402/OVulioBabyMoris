//
//  PodcastsVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-08-26.
//

import UIKit

class PodcastsVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var HeaderArr = ["Journrys", "Category 2","Category 3" , "Category 4"]
    
    var articleCellHeight = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setUpBackground()
        setUpNavigationBar()
        setupTableView()
        
    }
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            titleString: "PodcastsVC.headlineLabel.text"~
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
    
    func setupTableView() {
        tableView.removeFromSuperview()
        tableView.layoutIfNeeded()
        tableView.layoutSubviews()
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PodcastArticleTableViewCell.self, forCellReuseIdentifier: "PodcastArticleTableViewCell")
        tableView.register(PodcastItemsTableViewCell.self, forCellReuseIdentifier: "PodcastItemsTableViewCell")
        view.addSubview(tableView)
        if let customNavBarView = customNavBarView {
            tableView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 0).isActive = true
        }else{
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.reloadData()
    }
}


extension PodcastsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return HeaderArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section  == HeaderArr.count - 1 {
            return 5
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == HeaderArr.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastArticleTableViewCell", for: indexPath) as! PodcastArticleTableViewCell
            cell.backgroundColor = .clear
            cell.label.text = "Article name"
            cell.Desclabel.text = "Some information about\nthis article"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastItemsTableViewCell", for: indexPath) as! PodcastItemsTableViewCell
            cell.backgroundColor = .clear
            cell.podcastItemTapped = {
                let vc = PodCastPlayerVC()
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let height: CGFloat
        if indexPath.section  == HeaderArr.count - 1 {
            if DeviceSize.isiPadDevice {
                return CGFloat(articleCellHeight / 2)
            }else{
                return CGFloat(articleCellHeight)
            }
        }else {
            return 210.pulseWithFont(withInt: 20)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 23))
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width - 40, height: 23))
        titleLabel.text = HeaderArr[section]
        titleLabel.textColor = appColor
        titleLabel.font = .mymediumSystemFont(ofSize: 14.pulse2Font())
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 23
    }
}
