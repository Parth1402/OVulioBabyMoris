//
//  CalendarVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-13.
//

import UIKit

struct LunarCalendarContentModel{
    let gender: GenderPrediction
    let month: String
    
    enum gender {
        case boy
        case girl
    }
}

class LunarCalendarVC: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    let yearPickerContainerView = UIView()
    let currentMonth = Calendar.current.component(.month, from: Date())
    let selectedYearLabel = UILabel()
    private let demoDataAlertImageButton = UIButton(type: .custom)
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 7.5
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(LunarCalendarCell.self, forCellWithReuseIdentifier: "LunarCalendarCell")
        return collectionView
    }()
    
    var lunarCalendarArray: [LunarCalendarContentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.view.backgroundColor = .white
        self.view.setUpBackground()
        setUpNavigationBar()
        setUpCollectionView()
        setUpYearPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        demoDataAlertImageButton.removeFromSuperview()
        if !isUserProMember() {
            demoDataAlertImageButton.setImage(UIImage(named: "demoDataAlertImage"), for: .normal)
            self.view.addSubview(demoDataAlertImageButton)
            // Button Animation
            demoDataAlertImageButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
            demoDataAlertImageButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
            demoDataAlertImageButton.addTarget(self, action: #selector(demoDataAlertImageButtonAction), for: .touchUpInside)
            demoDataAlertImageButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                demoDataAlertImageButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                demoDataAlertImageButton.centerYAnchor.constraint(equalTo: self.customNavBarView!.centerYAnchor),
                demoDataAlertImageButton.widthAnchor.constraint(equalToConstant: 44),
                demoDataAlertImageButton.heightAnchor.constraint(equalToConstant: 44),
            ])
        }
    }
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }

    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
    @objc func demoDataAlertImageButtonAction(_ sender: UIButton) {
        sender.showAnimation {
            let vc = DemoDataAlertVC()
            vc.didPurchaseSuccessfully = {
                self.viewDidLoad()
            }
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: nil)
        }
    }
    func setUpNavigationBar() {
            customNavBarView = CustomNavigationBar(
                leftImage: UIImage(named: "backButtonImg"),
                titleString: "LunarCalendarVC.headlineLabel.text"~)

        
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
    
    func setUpYearPickerView() {
        
        yearPickerContainerView.backgroundColor = .white
        yearPickerContainerView.layer.cornerRadius = 20
        self.view.addSubview(yearPickerContainerView)
        yearPickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        if let customNavBarView = customNavBarView {
            yearPickerContainerView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        }else{
            yearPickerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        NSLayoutConstraint.activate([
            yearPickerContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: DeviceSize.isiPadDevice ? 30 : 15),
            yearPickerContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: DeviceSize.isiPadDevice ? -30 : -15),
            yearPickerContainerView.heightAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 90 : 70)
        ])
        
        let yearButtonView = UIView()
        yearButtonView.backgroundColor = appColor
        yearButtonView.layer.cornerRadius = 12
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCustomPopup))
        yearButtonView.addGestureRecognizer(tapGesture)
        yearButtonView.translatesAutoresizingMaskIntoConstraints = false
        yearPickerContainerView.addSubview(yearButtonView)
        NSLayoutConstraint.activate([
            yearButtonView.centerYAnchor.constraint(equalTo: yearPickerContainerView.centerYAnchor),
            yearButtonView.trailingAnchor.constraint(equalTo: yearPickerContainerView.trailingAnchor, constant: -15),
        ])
        
        let topDownYearImageView = UIImageView()
        topDownYearImageView.image = UIImage(named: "yearUpDownImg")
        topDownYearImageView.translatesAutoresizingMaskIntoConstraints = false
        yearButtonView.addSubview(topDownYearImageView)
        NSLayoutConstraint.activate([
            topDownYearImageView.trailingAnchor.constraint(equalTo: yearButtonView.trailingAnchor, constant: -12),
            topDownYearImageView.centerYAnchor.constraint(equalTo: yearButtonView.centerYAnchor),
            topDownYearImageView.widthAnchor.constraint(equalToConstant: 25),
            topDownYearImageView.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        selectedYearLabel.textColor = .white
        selectedYearLabel.textAlignment = .center
        selectedYearLabel.text = "\(ProfileDataManager.shared.selectedYearForLunarCalendar)"
        selectedYearLabel.font = UIFont.systemFont(ofSize: 16.pulse2Font())
        selectedYearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearButtonView.addSubview(selectedYearLabel)
        NSLayoutConstraint.activate([
            selectedYearLabel.leadingAnchor.constraint(equalTo: yearButtonView.leadingAnchor, constant: 20),
            selectedYearLabel.topAnchor.constraint(equalTo: yearButtonView.topAnchor, constant: 8),
            selectedYearLabel.trailingAnchor.constraint(equalTo: topDownYearImageView.leadingAnchor, constant: -8),
            selectedYearLabel.bottomAnchor.constraint(equalTo: yearButtonView.bottomAnchor, constant: -8)
        ])
        
        let chooseYearStaticLabel = UILabel()
        chooseYearStaticLabel.text = "LunarCalendarVC.ChooseYear.text"~
        chooseYearStaticLabel.textColor = appColor
        chooseYearStaticLabel.font = UIFont.systemFont(ofSize: 16.pulse2Font())
        chooseYearStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        yearPickerContainerView.addSubview(chooseYearStaticLabel)
        NSLayoutConstraint.activate([
            chooseYearStaticLabel.leadingAnchor.constraint(equalTo: yearPickerContainerView.leadingAnchor, constant: DeviceSize.isiPadDevice ? 30 : 15),
            chooseYearStaticLabel.centerYAnchor.constraint(equalTo: yearPickerContainerView.centerYAnchor),
            chooseYearStaticLabel.trailingAnchor.constraint(equalTo: yearButtonView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -30 : -15),
        ])
    }
    
    func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset =  UIEdgeInsets(top: DeviceSize.isiPadDevice ? 95 : 55, left: 0, bottom: 55, right: 0)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.isiPadDevice ? 30 : 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DeviceSize.isiPadDevice ? -30 : -15),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44 + 30)
        ])
        setUpLunarCalendarData()
    }
    
    func setUpLunarCalendarData() {
        if var motherBirthDate = ProfileDataManager.shared.motherBirthdate {
            let calendar = Calendar.current
            if !isUserProMember() {
                motherBirthDate = (Date().addMonth(-220)!)
            }
            let components = calendar.dateComponents([.year, .month, .day], from: motherBirthDate)
            let year = components.year
            let month = components.month
            let day = components.day
            if let year = year, let month = month, let day = day {
                self.lunarCalendarArray = genderPredictions(forYear: ProfileDataManager.shared.selectedYearForLunarCalendar, birthDay: day, birthMonth: month, birthYear: year)
                collectionView.alpha = 1
                collectionView.reloadData()
            }
        }else{
            let calendar = Calendar.current
            let motherBirthDate = Date().addMonth(-240)!
            let components = calendar.dateComponents([.year, .month, .day], from: motherBirthDate)
            let year = components.year
            let month = components.month
            let day = components.day
            if let year = year, let month = month, let day = day {
                self.lunarCalendarArray = genderPredictions(forYear: ProfileDataManager.shared.selectedYearForLunarCalendar, birthDay: day, birthMonth: month, birthYear: year)
                collectionView.alpha = 0.6
                collectionView.reloadData()
            }
        }
    }
}

// MARK: Actions
extension LunarCalendarVC {
    @objc func showCustomPopup(_ sender: UITapGestureRecognizer) {
        sender.view?.showAnimation {
            let vc = YearPickerPopUpVC()
            vc.yearSelectionCallBack = { year in
                ProfileDataManager.shared.updateSelectedYearForLunarCalendar(year)
                self.selectedYearLabel.text = "\(year)"
                self.setUpLunarCalendarData()
            }
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: nil)
        }
        
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension LunarCalendarVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lunarCalendarArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LunarCalendarCell", for: indexPath) as! LunarCalendarCell
        cell.backgroundColor = .clear
        cell.setupContent(data: lunarCalendarArray[indexPath.row])
        if indexPath.row == (currentMonth - 1) {
            cell.cellGradientImageView.image = UIImage(named: lunarCalendarArray[indexPath.row].gender == .boy ? "lunarCalendarBoyGredientIMG" : "lunarCalendarGirlGredientIMG")
            cell.monthTitleLabel.textColor = .white
            cell.boyOrGirlLabel.textColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if DeviceSize.isiPadDevice{
            return CGSize(width: (collectionView.widthOfView / 4) - 15, height: 168)
        }
        return CGSize(width: (collectionView.widthOfView / 2) - 5, height: (collectionView.widthOfView / 2) - collectionView.widthOfView / 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.showAnimation({
            
        })
    }
}
