//
//  MainViewController.swift
//  swap
//
//  Created by SUNG on 1/29/24.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        
    }
    
    //MARK: Action
    @IBAction func calendarAddButtonClicked(_ sender: UIButton) {
        if let calendarAddVC = storyboard?.instantiateViewController(withIdentifier: "CalendarAddViewController") {
            
            present(calendarAddVC, animated: true)
        }
    }
}
