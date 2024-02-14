//
//  MainViewController.swift
//  swap
//
//  Created by SUNG on 1/29/24.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    //MARK: Outlet
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var weekCalendar: FSCalendar!
    @IBOutlet weak var calendarHeader: UILabel!
    
    let headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 MM월"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "KST")
        return formatter
    }()
    
    override func viewDidLoad() {
//                for key in UserDefaults.standard.dictionaryRepresentation().keys {
//                    UserDefaults.standard.removeObject(forKey: key.description)
//                } // <userdefaults clear code>
        mainTableView.dataSource = self
        mainTableView.delegate = self
        weekCalendar.dataSource = self
        weekCalendar.delegate = self
        tabBar.delegate = self
        
        weekCalendar.scope = .week
        weekCalendar.locale = Locale(identifier: "ko_kr")
        weekCalendar.headerHeight = 0
        weekCalendar.weekdayHeight = 24
        weekCalendar.appearance.weekdayFont = UIFont(name: "BM JUA_OTF", size: 16.0)
        weekCalendar.appearance.weekdayTextColor = UIColor(named: "TextColor")
        weekCalendar.appearance.headerTitleColor = .clear
        weekCalendar.appearance.headerMinimumDissolvedAlpha = 0
        weekCalendar.appearance.titleFont = UIFont(name: "BM JUA_OTF", size: 16.0)
        weekCalendar.appearance.titleDefaultColor = UIColor(named: "TextColor")
        weekCalendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        weekCalendar.appearance.todayColor = .none
        weekCalendar.appearance.selectionColor = .red
        
        calendarHeader.text = headerDateFormatter.string(from: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        weekCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    //MARK: Function
    func presentTabBar(withIdentifier identifier: String) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[0] {
            
        } else if item == tabBar.items?[1] {
            presentTabBar(withIdentifier: "AttaintViewController")
        } else if item == tabBar.items?[2] {
            presentTabBar(withIdentifier: "TrophyViewController")
        }
    }
    
    //MARK: Action
    @IBAction func calendarAddButtonClicked(_ sender: UIButton) {
        if let calendarAddVC = storyboard?.instantiateViewController(withIdentifier: "CalendarAddViewController") {
            present(calendarAddVC, animated: true)
        }
    }
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        if let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingModalViewController") {
            present(settingVC, animated: true)
        }
    }
    @IBAction func recordEditButtonClicked(_ sender: UIButton) {
        if let recordVC = storyboard?.instantiateViewController(withIdentifier: "RecordViewController") {
            present(recordVC, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = weekCalendar.currentPage
        calendarHeader.text = headerDateFormatter.string(from: currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarHeader.text = headerDateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        if day == 0 { return .systemRed } else { return UIColor(named: "TextColor") }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SwapList.swapLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        let item = SwapList.swapLists[indexPath.row]
        cell.titleLabel.text = item.title
        cell.checkButton.isSelected = item.isCompleted
        return cell
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITabBarDelegate {
    
}

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
}

