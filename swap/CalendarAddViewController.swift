//
//  CalendarAddViewController.swift
//  swap
//
//  Created by SUNG on 1/30/24.
//

import UIKit
import FSCalendar

class CalendarAddViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    //MARK: Outlet
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    var monthCalendar: FSCalendar!
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monthCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    //MARK: function
    func setupViews() {
        // FSCalendar 생성 및 설정
        monthCalendar = FSCalendar(frame: CGRect(x: startDateButton.frame.minX, y: startDateButton.frame.maxY + 230, width: 200, height: 200))
        monthCalendar.backgroundColor = UIColor(named: "InputColor")
        monthCalendar.layer.cornerRadius = 20
        monthCalendar.layer.masksToBounds = true
        monthCalendar.isHidden = true
        monthCalendar.delegate = self
        monthCalendar.dataSource = self
        
        monthCalendar.appearance.headerMinimumDissolvedAlpha = 0
        monthCalendar.rowHeight = 20
        monthCalendar.appearance.titleTodayColor = UIColor(named: "TextColor")
        monthCalendar.appearance.todayColor = .clear
        monthCalendar.appearance.selectionColor = .red
        monthCalendar.placeholderType = .none
        monthCalendar.locale = Locale(identifier: "ko_kr")
        monthCalendar.appearance.headerDateFormat = "YYYY년 MM월 dd일"
        monthCalendar.appearance.headerTitleFont = UIFont(name: "BM JUA_OTF", size: 16.0)
        monthCalendar.appearance.headerTitleColor = UIColor(named: "TextColor")
        monthCalendar.appearance.weekdayFont = UIFont(name: "BM JUA_OTF", size: 16.0)
        monthCalendar.appearance.weekdayTextColor = UIColor(named: "TextColor")
        monthCalendar.appearance.titleFont = UIFont(name: "BM JUA_OTF", size: 16.0)
        monthCalendar.appearance.titleDefaultColor = UIColor(named: "TextColor")
        monthCalendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        view.addSubview(monthCalendar)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if startDateButton.isSelected {
            selectedStartDate = date
            startDateButton.setTitle(dateFormatter.string(from: date), for: .normal)
            startDateButton.titleLabel?.font = UIFont(name: "BM JUA_OTF", size: 16.0)
        } else if endDateButton.isSelected {
            selectedEndDate = date
            endDateButton.setTitle(dateFormatter.string(from: date), for: .normal)
            endDateButton.titleLabel?.font = UIFont(name: "BM JUA_OTF", size: 16.0)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendar.isHidden = true
    }
    
    //MARK: Action
    @IBAction func alarmButtonClicked(_ sender: UIButton) {
        if let alarmVC = storyboard?.instantiateViewController(withIdentifier: "AlarmModalViewController") {
            alarmVC.modalPresentationStyle = .overFullScreen
            present(alarmVC, animated: true)
        }
    }
    @IBAction func startCalendarHidden(_ sender: UIButton) {
        monthCalendar.frame = CGRect(x: sender.frame.minX, y: sender.frame.maxY + 235, width: 200, height: 200)
        monthCalendar.isHidden = monthCalendar.isHidden ? false : true
        sender.isSelected = !monthCalendar.isHidden
        endDateButton.isSelected = false
    }
    @IBAction func endCalendarHidden(_ sender: UIButton) {
        monthCalendar.frame = CGRect(x: sender.frame.minX, y: sender.frame.maxY + 305, width: 200, height: 200)
        monthCalendar.isHidden = monthCalendar.isHidden ? false : true
        sender.isSelected = !monthCalendar.isHidden
        startDateButton.isSelected = false
    }
    
    
    
}
