//
//  CalendarAddViewController.swift
//  swap
//
//  Created by SUNG on 1/30/24.
//

import UIKit

class CalendarAddViewController: UIViewController {
    override func viewDidLoad() {
    }
    
    //MARK: Action
    @IBAction func alarmButtonClicked(_ sender: UIButton) {
        if let alarmVC = storyboard?.instantiateViewController(withIdentifier: "AlarmModalViewController") {
            alarmVC.modalPresentationStyle = .overFullScreen
            present(alarmVC, animated: true)
        }
    }
}
