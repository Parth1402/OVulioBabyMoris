//
//  FavouriteNameVC.swift
//  Ovulio Baby
//
//  Created by USER on 14/04/25.
//

import UIKit

class FavouriteNameVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    var genderUpdationProtocolDelegate: GenderUpdationProtocol?
    var isPresentedForProfile = true
    var dismissedWithOutData: ((Bool) -> Void)?
    
    var isNameGenerate = false
    
    var sectionsToShow: [(title: String, names: [String])] = []
    
    var GirlNameArr = ["Emma","Emma","Emma","Jessica","Emma","Emma","Emma","Emma"]
    var BoysNameArr = ["Robert","Aaron","Emma","Jessica", "Emma","Emma","Emma","Emma"]
    var UnisexNameArr = ["Emma","Emma","Emma","Jessica","Emma","Emma","Emma","Emma"]
    
    
    
    var NameGenerateContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameGenerateDataBeforeSaving.RegionName = ""
        NameGenerateDataBeforeSaving.isRegionNameChanged = false
        self.view.setUpBackground()
        
        self.view.addSubview(NameGenerateContentContainer)
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                NameGenerateContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                NameGenerateContentContainer.widthAnchor.constraint(equalToConstant: 460),
                NameGenerateContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                NameGenerateContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }else{
            NSLayoutConstraint.activate([
                NameGenerateContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                NameGenerateContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                NameGenerateContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                NameGenerateContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        NameGenerateContentContainer.addSubview(tableView)
        setUpNavigationBar()
        setUpTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let girls = NameGenerateManager.shared.getFavouriteNames(for: .girls)
        let boys = NameGenerateManager.shared.getFavouriteNames(for: .boys)
        let unisex = NameGenerateManager.shared.getFavouriteNames(for: .unisex)
        
        sectionsToShow.removeAll()
        
        if !girls.isEmpty {
            sectionsToShow.append((title: "FavouriteNameVC.girlsNames.text"~, names: girls))
        }
        if !boys.isEmpty {
            sectionsToShow.append((title: "FavouriteNameVC.boysNames.text"~, names: boys))
        }
        if !unisex.isEmpty {
            sectionsToShow.append((title: "FavouriteNameVC.unisexNames.text"~, names: unisex))
        }
        
        //        sectionsToShow.append((title: "Girls names:", names: GirlNameArr))
        //        sectionsToShow.append((title: "Boys names:", names: BoysNameArr))
        //        sectionsToShow.append((title: "Unisex names:", names: UnisexNameArr))
        
        
        tableView.reloadData()
    }
    
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceHorizontal = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        
        tableView.register(FavouriteNameTableViewCell.self, forCellReuseIdentifier: "FavouriteNameTableViewCell")
        
        NameGenerateContentContainer.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: customNavBarView?.bottomAnchor ?? NameGenerateContentContainer.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: NameGenerateContentContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: NameGenerateContentContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: NameGenerateContentContainer.bottomAnchor)
        ])
    }
    
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            titleString: "FavouriteNameVC.headlineLabel.text"~
        )
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                
                if self.isNameGenerate {
                    self.dismiss(animated: true)
                }else {
                 
                        
                        let homeVC = HomeViewController()
                    homeVC.needToShowSalesScreen = true
                    homeVC.modalPresentationStyle = .fullScreen
                    homeVC.isNameGenerateScreen = true
                    self.present(homeVC, animated: true)
                    }
           
            }
            
            customNavBarView.rightButtonTapped = {
                self.handleOptionButtonTap()
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
    
}


// MARK: UIAction
extension FavouriteNameVC {
    
    func handleOptionButtonTap() {
        let vc = OptionsVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    func handleProfileButtonTap() {
        let vc = ProfileVC()
        //  vc.genderUpdationProtocolDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    func showChooseRegionVC() {
        DispatchQueue.main.async {
            let destinationViewController = ChooseRegionVC()
            destinationViewController.modalPresentationStyle = .fullScreen
            destinationViewController.selectedCountry = NameGenerateDataBeforeSaving.RegionName
            self.present(destinationViewController, animated: false, completion: nil)
        }
    }
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    func handleFieldChange(_ indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        let nameIndex = indexPath.row
        
        guard sectionIndex < sectionsToShow.count else { return }
        
        var section = sectionsToShow[sectionIndex]
        
        guard nameIndex < section.names.count else { return }
        
        // Remove name from section
        section.names.remove(at: nameIndex)
        
        // Save updated list
        switch section.title {
        case "FavouriteNameVC.girlsNames.text"~:
            NameGenerateManager.shared.saveFavouriteNames(section.names, for: .girls)
        case "FavouriteNameVC.boysNames.text"~:
            NameGenerateManager.shared.saveFavouriteNames(section.names, for: .boys)
        case "FavouriteNameVC.unisexNames.text"~:
            NameGenerateManager.shared.saveFavouriteNames(section.names, for: .unisex)
        default:
            break
        }
        
        if section.names.isEmpty {
            sectionsToShow.remove(at: sectionIndex)
            tableView.performBatchUpdates({
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
            }, completion: { _ in
                self.tableView.reloadData()
            })
        } else {
            sectionsToShow[sectionIndex] = section
            tableView.performBatchUpdates({
                tableView.reloadRows(at: [IndexPath(row: 0, section: sectionIndex)], with: .automatic)
            }, completion: nil)
        }
        
        //        if section.names.isEmpty {
        //            // Remove the entire section
        //            sectionsToShow.remove(at: sectionIndex)
        //            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: sectionIndex)) as? FavouriteNameTableViewCell {
        //                tableView.beginUpdates()
        //                cell.SelectedCell = indexPath
        //                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        //                tableView.endUpdates()
        //            }
        //        } else {
        //            // Update the section's data
        //            sectionsToShow[sectionIndex] = section
        //
        //            // Get the cell and update it
        //            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: sectionIndex)) as? FavouriteNameTableViewCell {
        //                tableView.beginUpdates()
        //                cell.SelectedCell = indexPath
        //                cell.configure(withTitle: section.title, Array: section.names)
        //                tableView.endUpdates()
        //            }
        //        }
    }
    
}

extension FavouriteNameVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsToShow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = appColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
        titleLabel.text = sectionsToShow[section].title
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteNameTableViewCell", for: indexPath) as! FavouriteNameTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.SelectedCell = indexPath
        
        cell.isFieldChanged = { nameIndex in
            let fullIndexPath = IndexPath(row: nameIndex.row, section: indexPath.section)
            self.handleFieldChange(fullIndexPath)
        }
        
        let section = sectionsToShow[indexPath.section]
        cell.configure(withTitle: section.title, Array: section.names)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

