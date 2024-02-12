//
//  RecordViewController.swift
//  swap
//
//  Created by SUNG on 2/2/24.
//

import UIKit
import FSCalendar

class RecordViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    //MARK: Outlet
    @IBOutlet weak var monthCalendar: FSCalendar!
    
    override func viewDidLoad() {
        monthCalendar.dataSource = self
        monthCalendar.delegate = self
        
        monthCalendar.appearance.headerMinimumDissolvedAlpha = 0
        monthCalendar.rowHeight = 30
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monthCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일"
        let headerText = dateFormatter.string(from: date)
        
        calendar.appearance.headerDateFormat = headerText
        monthCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date)
        if day == 1 {
            return .red
        } else {
            return UIColor(named: "TextColor")
        }
    }
    
}
