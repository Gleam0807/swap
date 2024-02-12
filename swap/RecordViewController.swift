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
    @IBOutlet weak var monthCaleandar: FSCalendar!
    
    override func viewDidLoad() {
        monthCaleandar.dataSource = self
        monthCaleandar.delegate = self
        
        monthCaleandar.appearance.headerMinimumDissolvedAlpha = 0
        monthCaleandar.rowHeight = 30
        monthCaleandar.appearance.titleTodayColor = UIColor(named: "TextColor")
        monthCaleandar.appearance.todayColor = .clear
        monthCaleandar.appearance.selectionColor = .red
        monthCaleandar.placeholderType = .none
        monthCaleandar.locale = Locale(identifier: "ko_kr")
        monthCaleandar.appearance.headerDateFormat = "YYYY년 MM월 dd일"
        monthCaleandar.appearance.headerTitleFont = UIFont(name: "BM JUA_OTF", size: 16.0)
        monthCaleandar.appearance.headerTitleColor = UIColor(named: "TextColor")
        monthCaleandar.appearance.weekdayFont = UIFont(name: "BM JUA_OTF", size: 16.0)
        monthCaleandar.appearance.weekdayTextColor = UIColor(named: "TextColor")
        monthCaleandar.appearance.titleFont = UIFont(name: "BM JUA_OTF", size: 16.0)
        monthCaleandar.appearance.titleDefaultColor = UIColor(named: "TextColor")
        monthCaleandar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monthCaleandar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일"
        let headerText = dateFormatter.string(from: date)
        
        calendar.appearance.headerDateFormat = headerText
        monthCaleandar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
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
