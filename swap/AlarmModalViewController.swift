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
    @IBOutlet weak var alramSound: UIButton!
    
    override func viewDidLoad() {
        
    }
    
    //MARK: Action
    @IBAction func cancelButtonClicekd(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let alramDatePicker = alramDatePicker.date
        // TODO
        // 1. 시간 값 저장 후 CalendarAddViewController로 넘기기
        // 2. CalendarAddViewController -> addButton Action에 SwapList.add부분에 alramDate추가 후 가져온 값 넣어주기
    }
    @IBAction func soundSeleted(_ sender: UIButton) {
    }
    
}
