//
//  AlarmModalViewController.swift
//  swap
//
//  Created by SUNG on 1/31/24.
//

import UIKit

class AlarmModalViewController: UIViewController {
    //MARK: outlet
    @IBOutlet weak var alramDatePicker: UIDatePicker!
    var alarmVCDataDelegate: AlarmVCDataDelegate?
    
    override func viewDidLoad() {
        
    }
    
    //MARK: Action
    @IBAction func cancelButtonClicekd(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let selectedDate = alramDatePicker.date
        let selectedTimeDateFormatter = DateFormatter().alarmConvertedDate.string(from: selectedDate)
        if let selectedTimeDate = DateFormatter().alarmConvertedDate.date(from: selectedTimeDateFormatter) {
            alarmVCDataDelegate?.alarmDateSet(alramTime: selectedTimeDate)
        }
        self.dismiss(animated: true)
    }
    
}
