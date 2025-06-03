//
//  SensualSecretsGameMenu.swift
//  Dirty Couple Game Calendar for Christmas
//
//  Created by Maurice Wirth on 27.04.23.
//

import UIKit
import FSPagerView
import Device
import GLScratchCard
import FirebaseFirestore
import Malert


class SensualSecretsGameMenu: UIViewController, FSPagerViewDelegate, FSPagerViewDataSource, GLScratchCarImageViewDelegate {
    
    let headlineLabel = CommonView.getCommonLabel(text: "ScratchCardMenu.headlineLabel.text"~, font: .boldSystemFont(ofSize: 24.pulse2Font()), lines: 0, alignment: .center)
    
    let closeButton: UIButton = {
        
        let buttonClose = UIButton()
        buttonClose.backgroundColor = UIColor.clear
        buttonClose.contentMode = .scaleAspectFit
        buttonClose.setImage(UIImage(named: "backButtonImg"), for: .normal)
        
        return buttonClose
    }()
    
    var affirmationData = AffirmationDataManager().retrieveAffirmationModel()
    
    
    
    var collectionViewScratchField: FSPagerView!
    let layoutCollectionViewScratchField = PagingCollectionViewLayout()
    
    let nextButton = CommonView.getCommonButton(title: "SensualSecretsGameMenu.nextButton.title", cornerRadius: 18)
    
    var currentCategoryIndex = 0
    var currentHeadlineIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setUpBackground()
        
        self.view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        if #available(iOS 11.0, *) {
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        } else {
            // Fallback on earlier versions
            closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0).isActive = true
        }
        
        closeButton.layer.cornerRadius = 17.0
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        
        // Button Animation
        closeButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        closeButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchDragOutside)
        
        
        
        
        
        var premiumVersionButtonWidth: Double = 0.0
        var premiumVersionButtonHeight: Double = 30.0
        
        self.view.addSubview(headlineLabel)
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        headlineLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60.0).isActive = true
        headlineLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60.0).isActive = true
        headlineLabel.text = NSLocalizedString("ScratchCardMenu.headlineLabel.text", comment: "")
        
        var scratchCardWidthHeight = UIScreen.main.bounds.width * 0.8
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                // Portrait
                scratchCardWidthHeight = UIScreen.main.bounds.width * 0.55
            } else {
                // Landscape
                scratchCardWidthHeight = UIScreen.main.bounds.width * 0.3
            }
            
        } else if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            scratchCardWidthHeight = UIScreen.main.bounds.width * 0.7
        }
        
        layoutCollectionViewScratchField.itemSize = CGSize(width: UIScreen.main.bounds.width, height: scratchCardWidthHeight)
        layoutCollectionViewScratchField.scrollDirection = .horizontal
        layoutCollectionViewScratchField.minimumLineSpacing = 10
        layoutCollectionViewScratchField.minimumInteritemSpacing = 10.0
        layoutCollectionViewScratchField.numberOfItemsPerPage = 1
        
        let leftRightInset = UIScreen.main.bounds.width * 0.1
        layoutCollectionViewScratchField.sectionInset = UIEdgeInsets(top: 0, left: leftRightInset, bottom: 0, right: leftRightInset)
        
        
        collectionViewScratchField = FSPagerView(frame: self.view.frame)
        collectionViewScratchField.itemSize = CGSize(width: UIScreen.main.bounds.width, height: scratchCardWidthHeight)
        collectionViewScratchField.transformer = FSPagerViewTransformer(type: .linear)
        collectionViewScratchField.register(SensualSecretsScratchFieldCell.self, forCellWithReuseIdentifier: "sensualSecretsScratchFieldCellId")
        collectionViewScratchField.backgroundColor = UIColor.clear
        //collectionViewAwardCards.isPagingEnabled = false
        collectionViewScratchField.isScrollEnabled = false
        //collectionViewAwardCards.showsHorizontalScrollIndicator = false
        collectionViewScratchField.backgroundColor = UIColor.clear
        collectionViewScratchField.isUserInteractionEnabled = true
        collectionViewScratchField.isInfinite = true
        
        self.view.addSubview(collectionViewScratchField)
        collectionViewScratchField.translatesAutoresizingMaskIntoConstraints = false
        collectionViewScratchField.topAnchor.constraint(equalTo: self.headlineLabel.bottomAnchor, constant: 50).isActive = true
        collectionViewScratchField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        collectionViewScratchField.heightAnchor.constraint(equalToConstant: scratchCardWidthHeight).isActive = true
        collectionViewScratchField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        //collectionViewAwardCards.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionViewScratchField.delegate = self
        collectionViewScratchField.dataSource = self
        
        
        
        self.view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -2.0).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        //nextButton.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            nextButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        } else {
            nextButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        }
        nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding).isActive = true
        
        nextButton.isUserInteractionEnabled = true
        nextButton.setTitle(NSLocalizedString("SensualSecretsGameMenu.nextButton.title", comment: ""), for: .normal)
        
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        
        // Button Animation
        nextButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
        nextButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
        nextButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        if let img = UIImage(named: "arrow-rightNextButton") {
            nextButton.setImage(img, for: .normal)
            nextButton.imageView?.contentMode = .scaleAspectFit
            nextButton.semanticContentAttribute = .forceRightToLeft
            // Adjust image insets as needed
            nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
        
        setUpIndexes()
        
    }
    
    func setUpIndexes()  {
        let unscratchedIndices = getIndexesOfUnscratched()
        
        guard !unscratchedIndices.isEmpty else {
            AffirmationDataManager.shared.clearAffirmationModel()
            affirmationData = AffirmationDataManager().retrieveAffirmationModel()
            setUpIndexes()
            return
        }
        
        let randomIndex = Int.random(in: 0..<unscratchedIndices.count)
        let randomUnscratchedIndex = unscratchedIndices[randomIndex]
        self.currentCategoryIndex = randomUnscratchedIndex[0]
        self.currentHeadlineIndex = randomUnscratchedIndex[1]
    }
    
    func getIndexesOfUnscratched() -> [[Int]] {
        var unscratchedIndices: [[Int]] = []

        for (categoryIndex, category) in affirmationData.enumerated() {
            for (headlineIndex, affirmation) in category.enumerated() {
                if !affirmation.isScratched {
                    unscratchedIndices.append([categoryIndex, headlineIndex])
                }
            }
        }

        return unscratchedIndices
    }
    
    @objc func nextButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        collectionViewScratchField.scrollToItem(at: 1, animated: true)
        self.setUpIndexes()
        self.delay(0.3) {
            self.collectionViewScratchField.reloadData()
            self.collectionViewScratchField.scrollToItem(at: 0, animated: false)
        }
        
    }
    
    
    //    func diceNextChallenge() -> Int {
    //
    //        var randomInt: Int = 0
    //        if isUserProMember() {
    //            randomInt = Int.random(in: 0...449)
    //        } else {
    //            randomInt = Int.random(in: 20...55)
    //        }
    //        return randomInt
    //
    //    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    @objc func closeButtonAction() {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        
        sender.touchDownAnimation {}
        
    }
    
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        
        sender.touchUpAnimation {}
        
    }
    
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 2
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "sensualSecretsScratchFieldCellId", at: index) as! SensualSecretsScratchFieldCell
        cell.scratchCard.addDelegate(delegate: self)
        cell.textView.text = self.affirmationData[currentCategoryIndex][currentHeadlineIndex].title~
        
        cell.scratchCard.image = UIImage(named:"positionCardGredientIMG")!
        cell.scratchCard.benchMarkScratchPercentage = 0
        
        return cell
        
    }
    
    
    func scratchpercentageDidChange(value: Float) {
        if value > 20.0 {
            self.affirmationData[currentCategoryIndex][currentHeadlineIndex].isScratched = true
            AffirmationDataManager().saveAffirmationModel(self.affirmationData)
        }
    }
    
    
    func didScratchStarted() {
        
        
        
    }
    
    
    func didScratchEnded() {
        
        
        
    }
    
}



class SensualSecretsScratchFieldCell: FSPagerViewCell {
    
    let positionImageView = UIImageView()
    let textView = UITextView()
    let scratchCard = GLScratchCardImageView()
    
    var scratchCardValue: Float = 0.0
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    func setupViews() {
        
        var cellWidth = UIScreen.main.bounds.width * 0.55
        var cellHeight = UIScreen.main.bounds.width * 0.55
        
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            cellWidth = UIScreen.main.bounds.width * 0.4
            cellHeight = UIScreen.main.bounds.width * 0.4
        }
        
        
        backgroundColor = UIColor.clear
        //layer.cornerRadius = cellWidth / 2
        
        
        
        var scratchCardWidthheight = UIScreen.main.bounds.width * 0.8
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                // Portrait
                scratchCardWidthheight = UIScreen.main.bounds.width * 0.55
            } else {
                // Landscape
                scratchCardWidthheight = UIScreen.main.bounds.width * 0.3
            }
            
        } else if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            scratchCardWidthheight = UIScreen.main.bounds.width * 0.7
        }
        
        
        self.addSubview(positionImageView)
        positionImageView.translatesAutoresizingMaskIntoConstraints = false
        positionImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        positionImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        positionImageView.heightAnchor.constraint(equalToConstant: scratchCardWidthheight).isActive = true
        positionImageView.widthAnchor.constraint(equalToConstant: scratchCardWidthheight).isActive = true
        
        positionImageView.layer.cornerRadius = scratchCardWidthheight / 2
        positionImageView.clipsToBounds = true
        //positionImageView.image = UIImage(named:"Scratch Adventure Launchscreen.jpg")!
        positionImageView.contentMode = .scaleAspectFit
        positionImageView.backgroundColor = .white
        positionImageView.isHidden = false
        
        
        
        
        
        self.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.centerXAnchor.constraint(equalTo: self.positionImageView.centerXAnchor, constant: 0.0).isActive = true
        textView.centerYAnchor.constraint(equalTo: self.positionImageView.centerYAnchor, constant: 0.0).isActive = true
        //textView.heightAnchor.constraint(equalToConstant: scratchCardWidthheight * 0.7).isActive = true
        textView.widthAnchor.constraint(equalToConstant: scratchCardWidthheight * 0.7).isActive = true
        
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = UIColor.clear
        if UIDevice.current.userInterfaceIdiom == .pad {  // if Device.size() > Size.screen7_9Inch {
            // Device is iPad
            textView.font = UIFont(name: "Poppins-Regular", size: 26.0)
        } else if Device.size() <= Size.screen4_7Inch {
            // Device is iPhone 6s or smaller
            textView.font = UIFont(name: "Poppins-Regular", size: 17.0)
        } else {
            textView.font = UIFont(name: "Poppins-Regular", size: 18.0)
        }
        textView.textColor = .black
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textAlignment = .center
        
        textView.isHidden = false
        
        
        
        
        
        self.addSubview(scratchCard)
        scratchCard.translatesAutoresizingMaskIntoConstraints = false
        scratchCard.topAnchor.constraint(equalTo: self.positionImageView.topAnchor, constant: 0.0).isActive = true
        scratchCard.bottomAnchor.constraint(equalTo: self.positionImageView.bottomAnchor, constant: 0.0).isActive = true
        scratchCard.leftAnchor.constraint(equalTo: self.positionImageView.leftAnchor, constant: 0.0).isActive = true
        scratchCard.rightAnchor.constraint(equalTo: self.positionImageView.rightAnchor, constant: 0.0).isActive = true
        
        scratchCard.layer.cornerRadius = scratchCardWidthheight / 2
        scratchCard.clipsToBounds = true
        
        scratchCard.image = UIImage(named:"positionCardGredientIMG")!
        scratchCard.lineWidth = 40
        scratchCard.lineType = .round
        scratchCard.benchMarkScratchPercentage = 0
        //scratchCard.addDelegate(delegate: self)
        scratchCard.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
