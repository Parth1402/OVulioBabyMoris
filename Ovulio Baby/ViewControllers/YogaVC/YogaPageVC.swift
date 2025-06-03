//
//  YogaPageVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-03-20.
//

import UIKit

class YogaPageVC: UIViewController, CustomYogaSegmentedControlDelegate  {
    
    var yogaVC = YogaVC()
    var prenatalVC = YogaPrentalVC()
    lazy var viewControllersArray: [UIViewController] = {
        return [
            yogaVC,
            prenatalVC
        ]
    }()
    
    var pageViewController: UIPageViewController!
    var pageControl: UIPageControl!
    let bottomSegmentView = CustomYogaSegmentedControl(buttonTitle: [
        YogaSegmentContentModel(title: "YogaVC.FertilityPositions.headlineLabel.text"~, image: "fertilityYogaImage"),
        YogaSegmentContentModel(title: "YogaVC.PrenatalYoga.headlineLabel.text"~, image: "prenatalYogaImage")])
    
    private let userDefaults = UserDefaults.standard
    private let lastShownYogaScreenIndexKey = "lastShownYogaScreenIndexKey"
    
    var lastShownScreenIndex: Int {
        get {
            return userDefaults.value(forKey: lastShownYogaScreenIndexKey) as? Int ?? 0
        }
        set {
            userDefaults.set(newValue, forKey: lastShownYogaScreenIndexKey)
        }
    }
    
    func updateLastShownScreenIndex(_ lastShownScreenIndex: Int) {
        self.lastShownScreenIndex = lastShownScreenIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        if pageViewController != nil {
            pageViewController.removeFromParent()
        }
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        bottomSegmentView.selectedIndex = lastShownScreenIndex
        pageViewController.setViewControllers([viewControllersArray[lastShownScreenIndex]], direction: .forward, animated: true, completion: nil)
        
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
        
        updateLastShownScreenIndex(index)
        
    }
    
}

protocol CustomYogaSegmentedControlDelegate:AnyObject {
    func change(to index:Int)
}

class YogaSegment: UIView {
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
            imageViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageViewContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageViewContainer.heightAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 60 : 50),
            imageViewContainer.widthAnchor.constraint(equalToConstant: DeviceSize.isiPadDevice ? 60 : 50),
            
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

struct YogaSegmentContentModel {
    let title: String
    let image: String
}

class CustomYogaSegmentedControl: UIView {
    
    private var buttonTitles:[YogaSegmentContentModel]!
    private var buttons: [YogaSegment]!
    private var selectorView: UIView!
    
    var textColor:UIColor = UIColor(hexString: "AA97BD") ?? (appColor!)
    var selectorViewColor: UIColor = UIColor(hexString: "9A73F9") ?? (appColor!)
    var selectorTextColor: UIColor = .white
    
    weak var delegate:CustomYogaSegmentedControlDelegate?
    
    var selectedIndex : Int = 0
    
    convenience init(buttonTitle:[YogaSegmentContentModel]) {
        self.init()
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[YogaSegmentContentModel]) {
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

extension CustomYogaSegmentedControl {
    
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
        
        buttons = [YogaSegment]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.addTarget(self, action:#selector(CustomYogaSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            let view = YogaSegment(image: buttonTitle.image, title: buttonTitle.title, topButton: button)
            buttons.append(view)
        }
        
    }
    
}
