//
//  YogaVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-03-18.
//

import UIKit
import Hero


class YogaVC: UIViewController {

    var customNavBarView: CustomNavigationBar?
    var tableView = UITableView(frame: CGRect.zero, style: .plain)
    var yogaFertilityData = YogaFertilityDataManager.shared.retrieveYogaFertilityModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setUpBackground()
        setUpNavigationBar()
        setupTableView()
        
    }
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            titleString: "YogaVC.headlineLabel.text"~
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
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(YogaTableViewCell.self, forCellReuseIdentifier: "YogaTableViewCell")
        view.addSubview(tableView)
        if let customNavBarView = customNavBarView {
            tableView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 0).isActive = true
        }else{
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        tableView.reloadData()
        
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension YogaVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YogaTableViewCell", for: indexPath) as! YogaTableViewCell
        cell.backgroundColor = .clear
        cell.yogaFertilityData = yogaFertilityData
        cell.setUpCell()
        cell.yogaCardDidTapped = { selectedCardIndex in
            
            // Check if Pro Member, else show Sales Page
            if isUserProMember() {
                
                // PRO Users
                let vc = YogaDetailVC()
                vc.yogaFertilityPositionElement = self.yogaFertilityData[selectedCardIndex]
                vc.saveAfterScratcingCard = {
                    YogaFertilityDataManager.shared.saveYogaFertilityModel(self.yogaFertilityData)
                    cell.yogaCardsCollectionView.reloadItems(at: [IndexPath(item: selectedCardIndex, section: 0)])
                }
                vc.hero.isEnabled = true
                vc.selectedCardIndex = selectedCardIndex
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
                
            } else {
                
                self.view.isHeroEnabled = true
                
                let destinationViewController = SalesVC()
                destinationViewController.modalPresentationStyle = .fullScreen
                destinationViewController.isHeroEnabled = true
                self.present(destinationViewController, animated: true, completion: nil)
                
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
