//
//  YearPickerPopUpVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-16.
//

import UIKit

class YearPickerPopUpVC: UIViewController {
    
    let blackBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let popUpContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "FFF2F2")
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = appColor
        label.text = "YearPickerPopUpVC.headlineLabel.text"~
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var yearSelectionCallBack: ((_ year: Int) -> Void)?
    
    let yearPicker = UIPickerView()
    let years = Array(2023...2035)
    var currentSelectedYearIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(blackBackground)
        NSLayoutConstraint.activate([
            blackBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blackBackground.topAnchor.constraint(equalTo: self.view.topAnchor),
            blackBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            blackBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCustomPopup))
        blackBackground.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(popUpContainerView)
        
        blackBackground.alpha = 0.0
        popUpContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        popUpContainerView.alpha = 0.0
        
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.popUpContainerView.transform = .identity
                self.popUpContainerView.alpha = 1.0
                self.blackBackground.transform = .identity
                self.blackBackground.alpha = 1.0
            }, completion: nil)
        }
        
        
        NSLayoutConstraint.activate([
            popUpContainerView.centerXAnchor.constraint(equalTo: blackBackground.centerXAnchor),
            popUpContainerView.centerYAnchor.constraint(equalTo: blackBackground.centerYAnchor, constant: -(self.view.bounds.height * 0.15)),
            popUpContainerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 30),
        ])
        
        popUpContainerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popUpContainerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: popUpContainerView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: popUpContainerView.trailingAnchor, constant: -18),
        ])
        
        configureYearPicker()
        setUpButtons()
        setUpCloseButton()
    }
    
    func setUpCloseButton() {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "calendarCloseButtonIcon"), for: .normal)
        closeButton.addTarget(self, action: #selector(dismissCustomPopupOnCloseTap), for: .touchUpInside)
        popUpContainerView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: popUpContainerView.topAnchor, constant: 9),
            closeButton.trailingAnchor.constraint(equalTo: popUpContainerView.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 60),
            closeButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func setUpButtons() {
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        popUpContainerView.addSubview(buttonView)
        
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setImage(UIImage(named: "previousYearButtonIcon"), for: .normal)
        button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        buttonView.addSubview(button1)
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setImage(UIImage(named: "nextYearButtonIcon"), for: .normal)
        button2.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)
        buttonView.addSubview(button2)
        NSLayoutConstraint.activate([
            buttonView.centerYAnchor.constraint(equalTo: yearPicker.centerYAnchor),
            buttonView.leadingAnchor.constraint(equalTo: yearPicker.trailingAnchor),
            
            button1.topAnchor.constraint(equalTo: buttonView.topAnchor),
            button1.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            button1.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            button1.widthAnchor.constraint(equalToConstant: (yearPicker.frame.height / 2) - 55),
            button1.heightAnchor.constraint(equalToConstant: (yearPicker.frame.height / 2) - 55),
            
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 0),
            button2.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            button2.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            button2.widthAnchor.constraint(equalToConstant: (yearPicker.frame.height / 2) - 55),
            button2.heightAnchor.constraint(equalToConstant: (yearPicker.frame.height / 2) - 55),
            button2.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor),
        ])
    }
    
    func configureYearPicker() {
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.backgroundColor = .white
        yearPicker.layer.cornerRadius = 10
        yearPicker.setValue(UIColor.clear, forKey: "backgroundColor")
        yearPicker.setValue(appColor, forKeyPath: "textColor")
        popUpContainerView.addSubview(yearPicker)
        yearPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            yearPicker.centerXAnchor.constraint(equalTo: popUpContainerView.centerXAnchor),
            yearPicker.heightAnchor.constraint(equalToConstant: 150),
            yearPicker.widthAnchor.constraint(equalToConstant: 150),
            yearPicker.bottomAnchor.constraint(equalTo: popUpContainerView.bottomAnchor, constant: -20),
        ])
        if let row = years.firstIndex(of: ProfileDataManager.shared.selectedYearForLunarCalendar) {
            currentSelectedYearIndex = row
            yearPicker.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    @objc func dismissCustomPopupOnCloseTap(_ sender: UIButton, delay: Double = 0.0) {
        sender.showAnimation {
            DispatchQueue.main.asyncAfter(deadline: ((.now()) + delay)) {
                UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
                    self.popUpContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.popUpContainerView.alpha = 0.0
                    self.dismiss(animated: true)
                }) { _ in
                    if let action = self.yearSelectionCallBack {
                        action(self.years[self.currentSelectedYearIndex])
                    }
                }
            }
        }
    }
    
    @objc func dismissCustomPopup(delay: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: ((.now()) + delay)) {
            UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
                self.popUpContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.popUpContainerView.alpha = 0.0
                self.dismiss(animated: true)
            }) { _ in
                if let action = self.yearSelectionCallBack {
                    action(self.years[self.currentSelectedYearIndex])
                }
            }
        }
    }
    
    @objc func button1Tapped(_ sender: UIButton) {
        sender.showAnimation {
            if self.currentSelectedYearIndex - 1 <= -1 {
                return
            }else{
                self.currentSelectedYearIndex -= 1
            }
            self.yearPicker.selectRow(self.currentSelectedYearIndex, inComponent: 0, animated: true)
        }
    }
    
    @objc func button2Tapped(_ sender: UIButton) {
        sender.showAnimation {
            if self.currentSelectedYearIndex + 1 >= self.years.count {
                return
            }else{
                self.currentSelectedYearIndex += 1
            }
            self.yearPicker.selectRow(self.currentSelectedYearIndex, inComponent: 0, animated: true)
        }
    }
}


extension YearPickerPopUpVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelectedYearIndex = row
    }
}
