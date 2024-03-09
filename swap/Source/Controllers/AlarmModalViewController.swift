//
//  AlarmModalViewController.swift
//  swap
//
//  Created by SUNG on 1/31/24.
//

import UIKit

class AlarmModalViewController: UIViewController {
    // MARK: Properties
    var alarmVCDataDelegate: AlarmVCDataDelegate?
    
    // MARK: outlets
    @IBOutlet weak var alramDatePicker: UIDatePicker!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let selectedDate = alramDatePicker.date
        let selectedTimeDateFormatter = DateFormatter().alarmConvertedDateFormatter.string(from: selectedDate)
        
        if let selectedTimeDate = DateFormatter().alarmConvertedDateFormatter.date(from: selectedTimeDateFormatter) {
            alarmVCDataDelegate?.alarmDateSet(alarmTime: selectedTimeDate)
        }
        
        self.dismiss(animated: true)
    }
}
