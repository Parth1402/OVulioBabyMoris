//
//  CalendarPageVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-16.
//

import UIKit

class CalendarPageVC: UIViewController, CustomSegmentedControlDelegate  {
    
    var lunarCalendarVC = LunarCalendarVC()
    lazy var viewControllersArray: [UIViewController] = {
        return [
            
        ]
    }()
    
    var pageViewController: UIPageViewController!
    var pageControl: UIPageControl!
    let bottomSegmentView = CustomSegmentedControl(buttonTitle: [
        CalendarSegmentContentModel(title: "CalendarPageVC.segment.LunarCalendar.headlineLabel.text"~, image: "Frame 489"),
        CalendarSegmentContentModel(title: "CalendarPageVC.segment.FertilityCalendar.headlineLabel.text"~, image: "Frame 488")])
    var genderUpdationProtocolDelegate: GenderUpdationProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lunarCalendarVC = LunarCalendarVC()
        viewControllersArray = [lunarCalendarVC,
                                UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OvulationCalendarVC") as! OvulationCalendarVC]
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        if pageViewController != nil {
            pageViewController.removeFromParent()
        }
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        bottomSegmentView.selectedIndex = LunarCalendarDataManager.shared.lastShownScreenIndex
        pageViewController.setViewControllers([viewControllersArray[LunarCalendarDataManager.shared.lastShownScreenIndex]], direction: .forward, animated: true, completion: nil)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        bottomSegmentView.delegate = self
        bottomSegmentView.backgroundColor = UIColor(hexString: "ECDAD9")
        bottomSegmentView.layer.cornerRadius = 20
        bottomSegmentView.clipsToBounds = true
        view.addSubview(bottomSegmentView)
        bottomSegmentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSegmentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: DeviceSize.isiPadDevice ? (ScreenSize.width * 0.1) : 15),
            bottomSegmentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: DeviceSize.isiPadDevice ? -(ScreenSize.width * 0.1) : -15),
            bottomSegmentView.heightAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 90 : 80),
            bottomSegmentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkProfileDataCompletion()
    }
    
    func checkProfileDataCompletion() {
        
        if ProfileDataManager.shared.lastPeriodDate == nil ||
            ProfileDataManager.shared.cycleLength == nil ||
            ProfileDataManager.shared.motherBirthdate == nil {
            handleProfileButtonTap()
        } else {
            if !isUserProMember() {
                if LunarCalendarDataManager.shared.freeUserScreenOpeneingCounter % 3 == 0 {
                    DispatchQueue.main.async {
                        let vc = DemoDataAlertVC()
                        vc.didPurchaseSuccessfully = {
                            self.viewDidLoad()
                        }
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: false, completion: nil)
                    }
                }
                LunarCalendarDataManager.shared.updateFreeUserScreenOpeneingCounter(LunarCalendarDataManager.shared.freeUserScreenOpeneingCounter + 1)
            }
        }
        
    }
    
    func handleProfileButtonTap() {
        
        let vc = ProfileVC()
        vc.isPresentedForProfile = false
        vc.genderUpdationProtocolDelegate = self.genderUpdationProtocolDelegate
        vc.dismissedWithOutData = { isWithoutData in
            if isWithoutData {
                self.dismiss(animated: true)
            } else {
                if !isUserProMember() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        LunarCalendarDataManager.shared.updateFreeUserScreenOpeneingCounter(LunarCalendarDataManager.shared.freeUserScreenOpeneingCounter + 1)
                        let vc = DemoDataAlertVC()
                        vc.didPurchaseSuccessfully = {
                            self.viewDidLoad()
                        }
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: false, completion: nil)
                    }
                }
                self.lunarCalendarVC.setUpLunarCalendarData()
            }
        }
        
        vc.isModalInPresentation = true
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func change(to index: Int) {
        changeToPage(at: index)
    }
    
    func changeToPage(at index: Int) {
        
        guard index >= 0 && index < viewControllersArray.count else {
            return
        }
        
        let currentIndex = viewControllersArray.firstIndex(of: self.viewControllersArray.first!) ?? 0
        
        if index > currentIndex {
            pageViewController.setViewControllers([viewControllersArray[index]], direction: .forward, animated: true, completion: nil)
        } else {
            pageViewController.setViewControllers([viewControllersArray[index]], direction: .reverse, animated: true, completion: nil)
        }
        
        LunarCalendarDataManager.shared.updateLastShownScreenIndex(index)
        
    }
    
}

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}


protocol CustomSegmentedControlDelegate:AnyObject {
    func change(to index:Int)
}

class Segment: UIView {
    var imageViewContainer = UIView()
    let segmentImageView = UIImageView()
    let titleLabel = UILabel()
    let topButton: UIButton
    
    init(image: String, title: String, topButton: UIButton) {
        self.topButton = topButton
        super.init(frame: .zero)
        //        self.backgroundColor = .brown
        
        
        addSubview(imageViewContainer)
        
        addSubview(titleLabel)
        addSubview(topButton)
        
        segmentImageView.image = UIImage(named: image)!
        segmentImageView.contentMode = .scaleAspectFit
        imageViewContainer.addSubview(segmentImageView)
        
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        segmentImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageViewContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageViewContainer.heightAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 80 : 70),
            imageViewContainer.widthAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 80 : 70),
            
            segmentImageView.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor),
            segmentImageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor),
            segmentImageView.trailingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor),
            segmentImageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor),
        ])
        
        titleLabel.text =  title
        titleLabel.textColor = UIColor(hexString: "AA97BD") ?? (appColor!)
        titleLabel.font = UIFont.systemFont(ofSize: 12.pulse2Font())
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        topButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topButton.topAnchor.constraint(equalTo: self.topAnchor),
            topButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct CalendarSegmentContentModel {
    let title: String
    let image: String
}

class CustomSegmentedControl: UIView {
    
    private var buttonTitles:[CalendarSegmentContentModel]!
    private var buttons: [Segment]!
    private var selectorView: UIView!
    
    var textColor:UIColor = UIColor(hexString: "AA97BD") ?? (appColor!)
    var selectorViewColor: UIColor = UIColor(hexString: "9A73F9") ?? (appColor!)
    var selectorTextColor: UIColor = .white
    
    weak var delegate:CustomSegmentedControlDelegate?
    
    var selectedIndex : Int = 0
    
    convenience init(buttonTitle:[CalendarSegmentContentModel]) {
        self.init()
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[CalendarSegmentContentModel]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
//    func setIndex(index:Int) {
//        buttons.forEach({ $0.titleLabel.textColor = textColor })
//        let button = buttons[index]
//        selectedIndex = index
//        button.titleLabel.textColor = selectorTextColor
//        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
//        UIView.animate(withDuration: 0.2) {
//            self.selectorView.frame.origin.x = selectorPosition
//        }
//    }
    
    @objc func buttonAction(sender: UIButton) {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        updateSelection(segment: sender)
        
    }
    
    func updateSelection(segment: UIButton) {
        
        for (buttonIndex, btn) in buttons.enumerated() {
            
            btn.titleLabel.textColor = textColor
            if btn.topButton == segment {
                
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                
                btn.titleLabel.textColor = selectorTextColor
                
            }
            
        }
        
    }
    
}

extension CustomSegmentedControl {
    
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
        DispatchQueue.main.async {
            self.updateSelection(segment: self.buttons[self.selectedIndex].topButton)
        }
    }
    
    private func configStackView() {
        
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    private func configSelectorView() {
        
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView()
        addSubview(selectorView)
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        selectorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        selectorView.widthAnchor.constraint(equalToConstant: selectorWidth).isActive = true
        selectorView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        selectorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        selectorView.backgroundColor = selectorViewColor
        selectorView.layer.cornerRadius = 20
        selectorView.clipsToBounds = true
        
    }
    
    private func createButton() {
        
        buttons = [Segment]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            let view = Segment(image: buttonTitle.image, title: buttonTitle.title, topButton: button)
            buttons.append(view)
        }
        
    }
    
}
