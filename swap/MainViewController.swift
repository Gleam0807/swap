//
//  MainViewController.swift
//  swap
//
//  Created by SUNG on 1/29/24.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, FSCalendarDataSource {
    //MARK: Outlet
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var weekCalendar: FSCalendar!
    @IBOutlet weak var calendarHeader: UILabel!
    var calendarDate: Date?
    
    let headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
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
        weekCalendar.appearance.todayColor = .clear
        weekCalendar.appearance.selectionColor = .red
        
        calendarHeader.text = headerDateFormatter.string(from: Date())
        if !SwapList.swapLists.isEmpty {
            weekCalendar.select(SwapList.swapLists[0].startDate)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("addDismissed"), object: nil)
    }
    
    @objc private func reloadTableView() {
        self.mainTableView.reloadData()
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
    @IBAction func checkButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var useCount = 0
        for i in 0..<SwapList.swapLists.count {
            if SwapList.swapLists[i].isDateCheck {
                useCount += 1
            }
        }
        return useCount > 0 ? useCount : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let useIndexes = SwapList.swapLists.enumerated().filter { $0.element.isDateCheck }.map { $0.offset }
        
        if useIndexes.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewNoneCell", for: indexPath) as? MainTableViewNoneCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        } else {
            let useIndex = useIndexes[indexPath.row]
            let item = SwapList.swapLists[useIndex]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.titleLabel.text = item.title
            cell.checkButton.isSelected = item.isCompleted
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !SwapList.swapLists.isEmpty {
            if let recordVC = storyboard?.instantiateViewController(withIdentifier: "RecordViewController") as? RecordViewController {
                for i in 0..<SwapList.swapLists.count {
                    recordVC.swapId = SwapList.swapLists[i].swapId
                    recordVC.swapTitle = SwapList.swapLists[i].title
                    recordVC.startDate = SwapList.swapLists[i].startDate
                    recordVC.endDate = SwapList.swapLists[i].endDate
                    recordVC.selectedDate = calendarDate ?? Date()
                }
                present(recordVC, animated: true)
            }
        }
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print(SwapList.swapLists[indexPath.row].swapId)
            SwapList.delete(swapId: SwapList.swapLists[indexPath.row].swapId)
            self.mainTableView.reloadData()
            success(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions:[deleteAction])
     }
}

extension MainViewController: UITabBarDelegate {
    
}

extension MainViewController: FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = weekCalendar.currentPage
        calendarHeader.text = headerDateFormatter.string(from: currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarDate = date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        for i in 0..<SwapList.swapLists.count {
            let swapStartDateComponents = calendar.dateComponents([.year, .month, .day], from: SwapList.swapLists[i].startDate)
            let swapEndDateComponents = calendar.dateComponents([.year, .month, .day], from: SwapList.swapLists[i].endDate)
            if let date = calendar.date(from: dateComponents),
               let swapStartDate = calendar.date(from: swapStartDateComponents),
               let swapEndDate = calendar.date(from: swapEndDateComponents) {
                if date >= swapStartDate && date <= swapEndDate {
                    SwapList.swapLists[i].isDateCheck = true
                } else {
                    SwapList.swapLists[i].isDateCheck = false
                }
            }
        }
        reloadTableView()
        calendarHeader.text = headerDateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        if day == 0 { return .systemRed } else { return UIColor(named: "TextColor") }
    }
}

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
}
class MainTableViewNoneCell: UITableViewCell {
}

