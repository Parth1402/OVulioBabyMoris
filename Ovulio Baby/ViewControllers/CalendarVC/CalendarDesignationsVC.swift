//
//  CalendarDesignationsVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-27.
//

import UIKit

class CalendarDesignationsVC: UIViewController {
    
    @IBOutlet weak var designationTitleLabel: UILabel!
    @IBOutlet weak var lblMenstruation: UILabel!
    @IBOutlet weak var lblPredictedMenstruation: UILabel!
    @IBOutlet weak var lblFertileWindow: UILabel!
    @IBOutlet weak var lblEstimatedDay: UILabel!
    @IBOutlet weak var lblSaveDay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designationTitleLabel.text = "CalendarDesignationsVC.details.menstruation.text"~
        lblPredictedMenstruation.text = "CalendarDesignationsVC.details.predictedMenstruation.text"~
        lblFertileWindow.text = "CalendarDesignationsVC.details.fertileWindow.text"~
        lblEstimatedDay.text = "CalendarDesignationsVC.details.estimatedDayOfOvulation.text"~
        lblSaveDay.text = "CalendarDesignationsVC.details.saveDay.text"~
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCustomPopup))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        // Error
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        self.dismiss(animated: true)
        
    }
    
    @objc func dismissCustomPopup() {
        self.dismiss(animated: true)
    }
    
}
