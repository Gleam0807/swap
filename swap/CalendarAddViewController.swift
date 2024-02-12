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
    var monthCalendar: FSCalendar!
    var selectedDate: Date?
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
        selectedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let headerText = dateFormatter.string(from: date)
        startDateButton.setTitle(headerText, for: .normal)
        startDateButton.titleLabel?.font = UIFont(name: "BM JUA_OTF", size: 16.0)
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
        monthCalendar.isHidden = !sender.isSelected
        sender.isSelected.toggle()
    }
    
    
}
