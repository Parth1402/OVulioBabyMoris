//
//  HomeViewController.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-07.
//

import UIKit
import FirebaseFirestore
import Malert


protocol GenderUpdationProtocol {
    func isGenderChanged()
}

protocol ShowReviewScreenProtocol {
    func needToShowReviewScreen()
}

class HomeCategoriesForList {
    var image, title, subTitle: String!
    var homeMenu: HomeMenus?
    
    init(image: String!, title: String!, subTitle: String!, homeMenu: HomeMenus?) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.homeMenu = homeMenu
    }
}
enum HomeMenus {
    case Sales, Games, DiceToSpice, Calendar, Yoga, Affirmation, LearningResources,NameGenerator, Podcast
}

class HomeViewController: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    var needToShowSalesScreen = true
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    
    let reviewAlertView = ReviewAlertView()
    var malert: Malert? = nil
    
    var isNameGenerateScreen = false
    
    
    var tableViewContentiPhone: [[HomeCategoriesForList]] = [
        [
            HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil) ],
        [
            HomeCategoriesForList(image: "upgradeCategoryBackground", title: "HomeViewController.categories.upgrade.headlineLabel.text"~, subTitle: "", homeMenu: .Sales),
            HomeCategoriesForList(image: "gamesCategoryBackground", title: "HomeViewController.categories.games.headlineLabel.text"~, subTitle: "HomeViewController.categories.games.headlineDescriptionLabel.text"~, homeMenu: .Games),
            HomeCategoriesForList(image: "diceCategoryBackground", title: "HomeViewController.categories.DiceToSpice.headlineLabel.text"~, subTitle: "HomeViewController.categories.DiceToSpice.headlineDescriptionLabel.text"~, homeMenu: .DiceToSpice),
            HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar),
            HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
            HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
            HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
            HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
            HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast),
        ]
    ]
    
    var tableViewContentiPad: [[[HomeCategoriesForList?]]] = [
        [
            [HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil)]],
        [
            [HomeCategoriesForList(image: "upgradeCategoryBackground", title: "HomeViewController.categories.upgrade.headlineLabel.text"~, subTitle: "", homeMenu: .Sales),
             HomeCategoriesForList(image: "gamesCategoryBackground", title: "HomeViewController.categories.games.headlineLabel.text"~, subTitle: "HomeViewController.categories.games.headlineDescriptionLabel.text"~, homeMenu: .Games)],
            [
                HomeCategoriesForList(image: "diceCategoryBackground", title: "HomeViewController.categories.DiceToSpice.headlineLabel.text"~, subTitle: "HomeViewController.categories.DiceToSpice.headlineDescriptionLabel.text"~, homeMenu: .DiceToSpice),
                HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar),
            ],
            [
                HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
                HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
            ],
            [
                HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
                HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
            ],
            [
                HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast),
                nil
            ]
        ]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateTableViewContentVariables()
        
        
        self.view.setUpBackground()
        setUpNavigationBar()
        addTableViewContent()
        
        // For internal test purposes
        let userDefaults = UserDefaults.standard
        //userDefaults.setValue(true, forKey: "didUnlockAppCompletely")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !isNameGenerateScreen {
            self.updateTableViewContentVariables()
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
                if !isUserProMember() && self.needToShowSalesScreen {
                    let vc = SalesVC()
                    vc.delegateShowReviewScreenProtocol = self
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .coverVertical
                    self.present(vc, animated: true, completion: nil)
                } else {
                    self.needToShowReviewScreen()
                }
                
            }
        }
        
  
        
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        
        // User should give review to continue
        let destinationViewController = RatingScreenMenu()
        destinationViewController.modalPresentationStyle = .fullScreen
        self.present(destinationViewController, animated: true, completion: nil)
        
    }
    */
    
    func updateTableViewContentVariables() {
        
        if RCValues.sharedInstance.bool(forKey: .temporarily_home_menu_layout_active) == true {
            
            if isUserProMember() {
                
                tableViewContentiPhone = [
                    [
                        HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil) ],
                    [
                        HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar),
                        HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
                        HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
                        HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
                        HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
                        HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast),
                    ]
                ]
                
                tableViewContentiPad = [
                    [
                        [HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil)]],
                    [
                        [
                            HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar),
                            HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
                        ],
                        [
                            HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
                            HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
                        ],
                        [
                            HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
                            HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast)
                        ]
                    ]
                ]
                
            } else {
                
                tableViewContentiPhone = [
                    [
                        HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil) ],
                    [
                        HomeCategoriesForList(image: "upgradeCategoryBackground", title: "HomeViewController.categories.upgrade.headlineLabel.text"~, subTitle: "", homeMenu: .Sales),
                        HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar),
                        HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
                        HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
                        HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
                        HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
                        HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast),
                    ]
                ]
                
                tableViewContentiPad = [
                    [
                        [HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil)]],
                    [
                        [HomeCategoriesForList(image: "upgradeCategoryBackground", title: "HomeViewController.categories.upgrade.headlineLabel.text"~, subTitle: "", homeMenu: .Sales),
                         HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar)],
                        [
                            HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
                            HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
                        ],
                        [
                            HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
                            HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
                        ],
                        [
                            HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast),
                            nil
                        ]
                    ]
                ]
                
            }
            
        } else if isUserProMember() {
            
            // User Defaults
            let userDefaults = UserDefaults.standard
            if userDefaults.value(forKey: "shouldUserGiveAppStoreReviewToUnlockApp") != nil && userDefaults.value(forKey: "shouldUserGiveAppStoreReviewToUnlockApp") as! Bool == false {
                
                // Users that purchased the App for 0$ lifetime
                // User already did give review
                
                tableViewContentiPhone = [
                    [
                        HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil) ],
                    [
                        HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar),
                        HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
                        HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
                        HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
                        HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
                        HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast),
                    ]
                ]
                
                tableViewContentiPad = [
                    [
                        [HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil)]],
                    [
                        [
                            HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar),
                            HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
                        ],
                        [
                            HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
                            HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
                        ],
                        [
                            HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
                            HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast)
                        ]
                    ]
                ]
                
            } else {
                
                // Paid Users
                
                tableViewContentiPhone = [
                    [
                        HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil) ],
                    [
                        HomeCategoriesForList(image: "gamesCategoryBackground", title: "HomeViewController.categories.games.headlineLabel.text"~, subTitle: "HomeViewController.categories.games.headlineDescriptionLabel.text"~, homeMenu: .Games),
                        HomeCategoriesForList(image: "diceCategoryBackground", title: "HomeViewController.categories.DiceToSpice.headlineLabel.text"~, subTitle: "HomeViewController.categories.DiceToSpice.headlineDescriptionLabel.text"~, homeMenu: .DiceToSpice),
                        HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar),
                        HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
                        HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
                        HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
                        HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
                        HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast),
                    ]
                ]
                
                tableViewContentiPad = [
                    [
                        [HomeCategoriesForList(image: "", title: "", subTitle: "", homeMenu: nil)]],
                    [
                        [
                            HomeCategoriesForList(image: "gamesCategoryBackground", title: "HomeViewController.categories.games.headlineLabel.text"~, subTitle: "HomeViewController.categories.games.headlineDescriptionLabel.text"~, homeMenu: .Games),
                            HomeCategoriesForList(image: "diceCategoryBackground", title: "HomeViewController.categories.DiceToSpice.headlineLabel.text"~, subTitle: "HomeViewController.categories.DiceToSpice.headlineDescriptionLabel.text"~, homeMenu: .DiceToSpice),
                        ],
                        [
                            HomeCategoriesForList(image: "calendarCategoryBackground", title: "HomeViewController.categories.calendar.headlineLabel.text"~, subTitle: "HomeViewController.categories.calendar.headlineDescriptionLabel.text"~, homeMenu: .Calendar),
                            HomeCategoriesForList(image: "yogaCategoryBackground", title: "HomeViewController.categories.Yoga.headlineLabel.text"~, subTitle: "HomeViewController.categories.Yoga.headlineDescriptionLabel.text"~, homeMenu: .Yoga),
                        ],
                        [
                            HomeCategoriesForList(image: "affirmationCategoryBackground", title: "HomeViewController.categories.Affirmation.headlineLabel.text"~, subTitle: "HomeViewController.categories.Affirmation.headlineDescriptionLabel.text"~, homeMenu: .Affirmation),
                            HomeCategoriesForList(image: "LearnCategoryBackground", title: "HomeViewController.categories.learningResources.headlineLabel.text"~, subTitle: "HomeViewController.categories.learningResources.headlineDescriptionLabel.text"~, homeMenu: .LearningResources),
                        ],
                        [
                            HomeCategoriesForList(image: "NameGenerateCategoryBackground", title: "HomeViewController.categories.NameGenetrate.headlineLabel.text"~, subTitle: "", homeMenu: .NameGenerator),
                            HomeCategoriesForList(image: "postcastCategoryBackground", title: "HomeViewController.categories.postcastCategory.headlineLabel.text"~, subTitle: "HomeViewController.categories.postcastCategory.headlineDescriptionLabel.text"~, homeMenu: .Podcast)
                        ]
                    ]
                ]
                
            }
            
        }
        
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "homeScreenMenu"),
            rightImage: UIImage(named: "homeScreenAvatar")
        )
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                self.handleOptionButtonTap()
            }
            customNavBarView.rightButtonTapped = {
                self.handleProfileButtonTap()
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.contentInset = .init(top: DeviceSize.isiPadDevice ? 20 : 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(YourGoalCell.self, forCellReuseIdentifier: "YourGoalCell")
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.register(CategoryCellForiPad.self, forCellReuseIdentifier: "CategoryCellForiPad")
        view.addSubview(tableView)
        
        if let customNavBarView = customNavBarView {
            tableView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension HomeViewController: GenderUpdationProtocol {
    func isGenderChanged() {
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
}

extension HomeViewController: ShowReviewScreenProtocol {
    
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

// MARK: UIAction
extension HomeViewController {
    
    func handleOptionButtonTap() {
        let vc = OptionsVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    func handleProfileButtonTap() {
        let vc = ProfileVC()
        vc.genderUpdationProtocolDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    func showCustomPopup() {
        let vc = YourGoalSelectionVC()
        vc.genderUpdationProtocolDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    
    func handleCategoriesTapAction(menu: HomeMenus) {
        
        switch menu {
        case .Sales:
            let vc = SalesVC()
            vc.delegateShowReviewScreenProtocol = self
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
            break
        case .Games:
            let vc = GamesVC()
            vc.legsUpScreenIsNeededToShow = {
                GamesDataManager.shared.updateNeedToShowLegsUpScreen(nil)
                let vc = GameLegsUpVC()
                self.present(vc, animated: true)
            }
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
            break
        case .DiceToSpice:
            let destinationViewController = DiceToSpiceGameMenu()
            destinationViewController.modalPresentationStyle = .overCurrentContext
            destinationViewController.modalTransitionStyle = .coverVertical
            self.present(destinationViewController, animated: true, completion: nil)
            break
        case .Calendar:
            let vc = CalendarPageVC()
            vc.genderUpdationProtocolDelegate = self
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
            break
        case .Yoga:
            let vc = YogaPageVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
            break
        case .Affirmation:
            let vc = SensualSecretsGameMenu()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
            break
        case .LearningResources:
            let vc = LearningResourcesVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
            break
        case .NameGenerator:
            let destinationViewController = NameGenerateVC()
            destinationViewController.modalPresentationStyle = .overCurrentContext
            destinationViewController.modalTransitionStyle = .coverVertical
            self.present(destinationViewController, animated: true, completion: nil)
            break
        case .Podcast:
            let vc = PodCastPlayerVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true)
            break
        default:
            break
        }
        
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DeviceSize.isiPadDevice ? tableViewContentiPad.count : tableViewContentiPhone.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeviceSize.isiPadDevice ? tableViewContentiPad[section].count : tableViewContentiPhone[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourGoalCell", for: indexPath) as! YourGoalCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.updateCellContent()
            
            return cell
            
        } else {
            
            if DeviceSize.isiPadDevice {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellForiPad", for: indexPath) as! CategoryCellForiPad
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.setUpCell(data1: tableViewContentiPad[indexPath.section][indexPath.row][0], data2: tableViewContentiPad[indexPath.section][indexPath.row][1])
                
                cell.categoryTapped = { menu in
                    self.handleCategoriesTapAction(menu: menu)
                }
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.cellBackgroundView.layer.cornerRadius = 20
                cell.cellBackgroundView.layer.masksToBounds = true
                
                if tableViewContentiPhone[indexPath.section][indexPath.row].homeMenu == .Sales {
                    
                    DispatchQueue.main.async {
                        
                        if let color1 = UIColor(hexString: "EFB8C2"),
                           let color2 = UIColor(hexString: "FFBACB") {
                            cell.cellBackgroundView.gradientBorder(
                                width: 5,
                                colors: [color1, color2],
                                andRoundCornersWithRadius: 18
                            )
                            
                        }
                        
                    }
                    
                }
                
                cell.categoryTitle.text = tableViewContentiPhone[indexPath.section][indexPath.row].title
                cell.categorySubtitle.text = tableViewContentiPhone[indexPath.section][indexPath.row].subTitle
                cell.backgroundImage.image = UIImage(named: tableViewContentiPhone[indexPath.section][indexPath.row].image ?? "gamesCategoryBackground")
                cell.setUpCell()
                
                return cell
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return createHeaderView1()
        } else if section == 1 {
            return createHeaderView2()
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 88 : 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if DeviceSize.isiPadDevice {
            let cell = tableView.cellForRow(at: indexPath)
            if indexPath.section == 0 {
                cell?.showAnimation({
                    self.showCustomPopup()
//                    let destinationViewController = NameGenerateVC()
//                    destinationViewController.modalPresentationStyle = .fullScreen
//                    self.present(destinationViewController, animated: false, completion: nil)
                })
            }
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.showAnimation({
            if indexPath.section == 0 {
                self.showCustomPopup()

//                let destinationViewController = NameGenerateVC()
//                destinationViewController.modalPresentationStyle = .fullScreen
//                self.present(destinationViewController, animated: false, completion: nil)
                
            } else {
                self.handleCategoriesTapAction(menu: self.tableViewContentiPhone[indexPath.section][indexPath.row].homeMenu ?? .Sales)
            }
        })
        
    }
    
    private func createHeaderView1() -> UIView {
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.text = "HomeViewController.headlineLabel.text"~
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 24.pulseWithFont(withInt: 4))
        headlineLabel.textColor = appColor
        headlineLabel.setFontScaleWithWidth()
        
        let headlineDescriptionLabel = UILabel()
        headlineDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineDescriptionLabel.text = "HomeViewController.headlineDescriptionLabel.text"~
        headlineDescriptionLabel.textColor = appColor
        headlineDescriptionLabel.font = UIFont.systemFont(ofSize: 15.pulse2Font())
        headlineDescriptionLabel.setFontScaleWithWidth()
        
        headerView.addSubview(headlineLabel)
        headerView.addSubview(headlineDescriptionLabel)
        
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headlineLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headlineLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            
            headlineDescriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headlineDescriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headlineDescriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 5)
        ])
        
        return headerView
        
    }
    
    
    private func createHeaderView2() -> UIView {
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = "HomeViewController.categories.headlineLabel.text"~
        categoryLabel.textColor = appColor
        categoryLabel.font = UIFont.mymediumSystemFont(ofSize: 14.pulse2Font())
        
        headerView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
        
    }
    
}
