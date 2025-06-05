//
//  NameGenerateVC.swift
//  Ovulio Baby
//
//  Created by USER on 09/04/25.
//

import UIKit
import AudioToolbox
import FirebaseFirestore

struct NameGeneratorInput {
    var category: String // e.g., "Boy"
    var region: String   // e.g., "India"
    var lastName: String // e.g., "Patel"
    var style: String    // e.g., "Modern"
    var length: String   // e.g., "Short"
    var localized: String   // e.g., "Short"
}

class NameGenerateDataBeforeSaving {
    static var RegionName = NameGenerateManager.shared.Region
    static var isRegionNameChanged = false
    static var LastName = NameGenerateManager.shared.LastName
    static var isLastNameChanged = false
    static var selectedGender = NameGenerateManager.shared.selectedGender
    static var isGenderChangeed = false
    static var ChooseStyle = NameGenerateManager.shared.ChooseStyle
    static var isChooseStyle = false
    static var ChooseLength = NameGenerateManager.shared.ChooseLength
    static var isChooseLength = false
    
    static var favouriteNames = NameGenerateManager.shared.getFavouriteNames(for: .boys)
}

class NameGenerateVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    var genderUpdationProtocolDelegate: GenderUpdationProtocol?
    var isPresentedForProfile = true
    var dismissedWithOutData: ((Bool) -> Void)?
    
    let StyleArr = ["NameGenerateVC.chooseStyle.label1.text"~,"NameGenerateVC.chooseStyle.label2.text"~,"NameGenerateVC.chooseStyle.label3.text"~,"NameGenerateVC.chooseStyle.label4.text"~,"NameGenerateVC.chooseStyle.label5.text"~,"NameGenerateVC.chooseStyle.label6.text"~]
    let lengthArr = ["NameGenerateVC.chooseLength.label1.text"~,"NameGenerateVC.chooseLength.label2.text"~,"NameGenerateVC.chooseLength.label3.text"~,"NameGenerateVC.chooseLength.label4.text"~,"NameGenerateVC.chooseLength.label5.text"~,"NameGenerateVC.chooseLength.label6.text"~]
    
    var NameGenerateContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var generateButtonDidableView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var generateButton: UIButton = {
        let button = UIButton()
        button.setTitle("NameGenerateVC.generateButton.text"~, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = buttonAppLightColor
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
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
        self.view.addSubview(generateButton)
        setUpNavigationBar()
        setUpSaveButton()
        setUpTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
            let girls = NameGenerateManager.shared.getFavouriteNames(for: .girls)
            let boys = NameGenerateManager.shared.getFavouriteNames(for: .boys)
            let unisex = NameGenerateManager.shared.getFavouriteNames(for: .unisex)
            
            // Check if any of the lists are non-empty
            let hasFavorites = !girls.isEmpty || !boys.isEmpty || !unisex.isEmpty

            // Show or hide the button based on that
        customNavBarView?.rightButton.isHidden = !hasFavorites
            
    
    }
    
    func setUpSaveButton() {
        if isPresentedForProfile {
            // Button Animation
            generateButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
            generateButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        }
        generateButton.addTarget(self, action:#selector(GenetareButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            generateButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            generateButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            generateButton.heightAnchor.constraint(equalToConstant: 50),
            generateButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        self.view.addSubview(generateButtonDidableView)
        generateButtonDidableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            generateButtonDidableView.topAnchor.constraint(equalTo: generateButton.topAnchor),
            generateButtonDidableView.leadingAnchor.constraint(equalTo: generateButton.leadingAnchor),
            generateButtonDidableView.trailingAnchor.constraint(equalTo: generateButton.trailingAnchor),
            generateButtonDidableView.bottomAnchor.constraint(equalTo: generateButton.bottomAnchor)
        ])
    }
    
    func setUpTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NameGenerateImagTextCell.self, forCellReuseIdentifier: "NameGenerateImagTextCell")
        tableView.register(NameGenetareGenderSelectionCell.self, forCellReuseIdentifier: "NameGenetareGenderSelectionCell")
        tableView.register(ChooseStyleLengthSelectionCell.self, forCellReuseIdentifier: "ChooseStyleLengthSelectionCell")
        if let customNavBarView = customNavBarView {
            tableView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo: NameGenerateContentContainer.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: NameGenerateContentContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: NameGenerateContentContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: generateButton.topAnchor, constant: -10),
        ])
        
    }
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            titleString: "NameGenerateVC.headlineLabel.text"~, rightImage: UIImage(named: "nameGenerate_like")
        )
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                self.dismiss(animated: true)
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
extension NameGenerateVC {
    
    func handleOptionButtonTap() {
        let vc = FavouriteNameVC()
        vc.isNameGenerate = true
        vc.modalPresentationStyle = .fullScreen
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
    
    func handleFieldChange() {
        
        if NameGenerateDataBeforeSaving.isChooseStyle ||
            NameGenerateDataBeforeSaving.isChooseLength ||
            NameGenerateDataBeforeSaving.isGenderChangeed ||
            NameGenerateDataBeforeSaving.isLastNameChanged ||
            NameGenerateDataBeforeSaving.isRegionNameChanged {
            generateButtonDidableView.isHidden = true
        } else {
            generateButtonDidableView.isHidden = false
        }
        
    }
    
    @objc func GenetareButtonTapped(sender: UIButton) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        
        if !isUserProMember()  {
            let vc = SalesVC()
            vc.delegateShowReviewScreenProtocol = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
            
        }else{
            
            let count = NameGenerateManager.shared.nameGenerateCount ?? 0
            if count <= 15 {
                
                self.showCustomLoader()
                
                
                let input = NameGeneratorInput(
                    category: NameGenerateDataBeforeSaving.selectedGender.rawValue == 1 ? "YourGoalSelectionVC.gender.boy.text"~ : NameGenerateDataBeforeSaving.selectedGender.rawValue == 2 ? "YourGoalSelectionVC.gender.girl.text"~ : "NameGenerateVC.gender.unisex.text"~ ,
                    region: NameGenerateDataBeforeSaving.RegionName ?? "",
                    lastName: NameGenerateDataBeforeSaving.LastName ?? "",
                    style: NameGenerateDataBeforeSaving.ChooseStyle ?? "",
                    length: NameGenerateDataBeforeSaving.ChooseLength ?? "", localized: MultiLanguage.MultiLanguageConst.currentAppleLanguage()
                    
                )
                
                
                var generatedNames: [(first: String, last: String)] = []
                
                NameGenerateManager.shared.generateNameWithAI(input: input) { name in
                    DispatchQueue.main.async {
                        self.hideCustomLoader()
                        
                        guard let fullName = name else {
                            print("Failed to generate name")
                            return
                        }
                        
                        print("Generated Name: \(fullName)")
                        
                        for (index, fullName) in fullName.reversed().enumerated() {
                            let components = fullName.split(separator: " ", maxSplits: 1).map(String.init)
                            let firstName = components.first ?? ""
                            let lastName = components.count > 1 ? components.last! : ""
                            generatedNames.append((first: firstName, last: lastName))
                            
                        }
                        
                        NameGenerateManager.shared.updatenameGenerateCount(count + 1)
                        let destinationViewController = SwipeNameCardVC()
                        destinationViewController.modalPresentationStyle = .fullScreen
                        destinationViewController.names = generatedNames
                        self.present(destinationViewController, animated: false, completion: nil)
                    }
                }
            }else {
                
                let alert = UIAlertController(title: "",
                                                     message: "You can reached the limit to generate name. Please contact support",
                                                     preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "OK", style: .default))
                       self.present(alert, animated: true)
                
            }
        }
    }
}
extension NameGenerateVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
         
                let cell = tableView.dequeueReusableCell(withIdentifier: "NameGenerateImagTextCell", for: indexPath) as! NameGenerateImagTextCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.isFieldChanged = {
                    self.handleFieldChange()
                }
            
            cell.isChooseRegionClick = {
                self.showChooseRegionVC()
            }
                cell.setupUI()
                return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameGenetareGenderSelectionCell", for: indexPath) as! NameGenetareGenderSelectionCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.isFieldChanged = {
                self.handleFieldChange()
            }
            cell.setupUI(headlineTitle: "NameGenerateVC.chooseName.text"~)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseStyleLengthSelectionCell", for: indexPath) as! ChooseStyleLengthSelectionCell
            cell.backgroundColor = .clear
            cell.SelectedCell = 0
            cell.selectionStyle = .none
            cell.isFieldChanged = {
                self.handleFieldChange()
            }
            cell.configure(withTitle: "NameGenerateVC.chooseStyle.text"~, Array: StyleArr)

            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseStyleLengthSelectionCell", for: indexPath) as! ChooseStyleLengthSelectionCell
            cell.backgroundColor = .clear
            cell.SelectedCell = 1
            cell.selectionStyle = .none
            cell.isFieldChanged = {
                self.handleFieldChange()
            }
          
            cell.configure(withTitle: "NameGenerateVC.chooseLength.text"~, Array: lengthArr)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NameGenerateVC: ShowReviewScreenProtocol {
    
    func needToShowReviewScreen() {
        
        if UserDefaults.standard.value(forKey: "shouldUserGiveAppStoreReviewToUnlockApp") == nil {
            
            // Do nothing
            
        } else if UserDefaults.standard.value(forKey: "shouldUserGiveAppStoreReviewToUnlockApp") as! Bool == false {
            
            // User already did give review
            
        } else {  // shouldUserGiveAppStoreReviewToUnlockApp == true
            
            let db = Firestore.firestore()
            let docRefActivationCodes = db.collection("tracking").document("SubmittedRatingViaRatingView")
            docRefActivationCodes.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    if let shouldUserGiveAppStoreReviewToUnlockAppFirestoreValue = document.data()!["shouldUserGiveAppStoreReviewToUnlockApp"] as? Bool {
                        print("shouldUserGiveAppStoreReviewToUnlockAppFirestoreValue \(shouldUserGiveAppStoreReviewToUnlockAppFirestoreValue)")
                        
                        if shouldUserGiveAppStoreReviewToUnlockAppFirestoreValue == true {
                            
                            // User should give review to continue
                            let destinationViewController = RatingScreenMenu()
                            destinationViewController.modalPresentationStyle = .fullScreen
                            self.present(destinationViewController, animated: true, completion: nil)
                            
                        } else {
                            
                            // Error
                            
                        }
                        
                    } else {
                        
                        // Error
                        
                    }
                    
                } else {
                    
                    // Error
                    
                }
                
            }
            
        }
    }
}
