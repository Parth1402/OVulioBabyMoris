//
//  GamesLocaionsCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-23.
//

import UIKit

class GamesLocaionsCell: UITableViewCell {
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    var locationsData: [LocationsModel]?
    var locationGetsCompleted: (() -> Void)?
    
    var UnlockForMoreFunButton: UIButton = {
        let button = UIButton()
        button.setTitle("GamesVC.UnlockForMoreFunButton.Locations.title"~, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = buttonAppLightColor
        button.layer.cornerRadius = 15
        button.layer.shadowColor = appColor?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        return button
    }()
    var UnlockForMoreFunButtonTap: (() -> Void)?
    
    let illustrationImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell(locations: [LocationsModel]?)  {
        self.locationsData = locations
        contentView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GamesExtrasPlaceCell.self, forCellReuseIdentifier: "GamesExtrasPlaceCell")
        self.contentView.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            self.tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension GamesLocaionsCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return locationsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsData?[section].places.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamesExtrasPlaceCell", for: indexPath) as! GamesExtrasPlaceCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.setUpCell(extrasData: locationsData?[indexPath.section].places[indexPath.row])
        cell.isUserInteractionEnabled = true
        if !isUserProMember() {
            if indexPath.row >= 3 {
                cell.setupblurView()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isUserProMember() {
            // Position the button over the 20th cell
            let indexPath = IndexPath(row: 7, section: 0) // Assuming the table has only one section
            if let cellFrame = tableView.rectForRow(at: indexPath) as? CGRect{
                // Use optional binding to safely unwrap the result
                tableView.addSubview(UnlockForMoreFunButton)
                // Button Animation
                UnlockForMoreFunButton.layer.shadowColor = appColor?.cgColor
                UnlockForMoreFunButton.layer.shadowOffset = CGSize(width: 0, height: 5)
                UnlockForMoreFunButton.layer.shadowOpacity = 0.4
                UnlockForMoreFunButton.layer.shadowRadius = 5
                UnlockForMoreFunButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
                UnlockForMoreFunButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
                UnlockForMoreFunButton.addTarget(self, action: #selector(UnlockForMoreFunButtonTapped), for: .touchUpInside)
                UnlockForMoreFunButton.frame = CGRect(x: DeviceSize.isiPadDevice ? (cellFrame.midX / 2) : 20, y: cellFrame.minY, width: DeviceSize.isiPadDevice ? (ScreenSize.width / 2) : (ScreenSize.width - 40), height: 55)
                self.delay(1.0) {
                    
                    self.startPulsingUnlockForMoreFunButton()
                    
                }
                
                illustrationImageView.image = UIImage(named: "sexExtrasIllustration")!
                illustrationImageView.contentMode = .scaleAspectFit
                tableView.addSubview(illustrationImageView)
                illustrationImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    illustrationImageView.bottomAnchor.constraint(equalTo: UnlockForMoreFunButton.topAnchor, constant: -10),
                    illustrationImageView.centerXAnchor.constraint(equalTo: UnlockForMoreFunButton.centerXAnchor),
                    illustrationImageView.heightAnchor.constraint(equalToConstant: 170),
                    illustrationImageView.widthAnchor.constraint(equalToConstant: UnlockForMoreFunButton.widthOfView * 0.8)
                ])
            }
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    func startPulsingUnlockForMoreFunButton() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 1.0
        pulse.toValue = 1.03
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        let pulseGroup = CAAnimationGroup()
        pulseGroup.duration = 3.0
        pulseGroup.repeatCount = .infinity
        pulseGroup.animations = [pulse]
        
        self.UnlockForMoreFunButton.layer.add(pulseGroup, forKey: "pulse")
        
    }
    
    @objc func UnlockForMoreFunButtonTapped(sender: UIButton) {
        sender.showAnimation {
            if let action = self.UnlockForMoreFunButtonTap {
                action()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        let headlineLabel = CommonView.getCommonLabel(text: locationsData?[section].headline ?? "Not found", font: .boldSystemFont(ofSize: 18.pulse2Font()))
        headerView.backgroundColor = .clear
        headerView.addSubview(headlineLabel)
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headlineLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            headlineLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            headlineLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
        
//        let pointsLabel = CommonView.getCommonLabel(text: "+\(locationsData?[section].points ?? 0) points", textColor: lightAppColor, font: .systemFont(ofSize: 14))
//        headerView.addSubview(pointsLabel)
//        NSLayoutConstraint.activate([
//            pointsLabel.leadingAnchor.constraint(equalTo: headlineLabel.trailingAnchor, constant: 10),
//            pointsLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
//            pointsLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
//        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.showAnimation({
            if indexPath.row >= 3 {
                if !isUserProMember() {
                    if let action = self.UnlockForMoreFunButtonTap {
                        action()
                    }
                    return
                }
            }
            if self.locationsData?[indexPath.section].places[indexPath.row].isAlreadyCompleted ?? false{
                self.locationsData?[indexPath.section].places[indexPath.row].isAlreadyCompleted = false
            }else{
                self.locationsData?[indexPath.section].places[indexPath.row].isAlreadyCompleted = true
            }
            tableView.reloadRows(at: [indexPath], with: .none)
            if let action = self.locationGetsCompleted {
                action()
            }
        })
    }
}
