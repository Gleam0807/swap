//
//  MainViewController.swift
//  swap
//
//  Created by SUNG on 1/29/24.
//

import UIKit
import FSCalendar

protocol SwapDataDelegate {
    func reloadData()
}

class MainViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var weekCalendar: FSCalendar!
    @IBOutlet weak var calendarHeader: UILabel!
    var calendarDate = Date()
    
    let headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
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
        weekCalendar.appearance.weekdayFont = .swapTextFont
        weekCalendar.appearance.weekdayTextColor = .swapTextColor
        weekCalendar.appearance.headerTitleColor = .clear
        weekCalendar.appearance.headerMinimumDissolvedAlpha = 0
        weekCalendar.appearance.titleFont = .swapTextFont
        weekCalendar.appearance.titleDefaultColor = .swapTextColor
        weekCalendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        weekCalendar.appearance.todayColor = .clear
        weekCalendar.appearance.selectionColor = .red
        
        calendarHeader.text = DateFormatter().displayDateFormatter.string(from: Date())
        if !SwapList.swapLists.isEmpty {
            weekCalendar.select(SwapList.swapLists[0].startDate)
        } else {
            weekCalendar.select(calendarDate)
        }
        
        if let selectedDate = weekCalendar.selectedDate {
            calendarDate = selectedDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainTableView.reloadData()
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
        if let calendarAddVC = storyboard?.instantiateViewController(withIdentifier: "CalendarAddViewController") as? CalendarAddViewController {
            calendarAddVC.currentDate = calendarDate
            calendarAddVC.swapDataDelegate = self
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
        let swapId = SwapList.swapLists[sender.tag].swapId
        SwapCompletedList.addToUpdate(swapId: swapId, completedDate: calendarDate, isCompleted: sender.isSelected)
    }
    
}

extension MainViewController: UITableViewDataSource {
    func compltedUpdate(_ cell: MainTableViewCell, _ useIndex: Int) {
        if let compltedIndexes = SwapCompletedList.swapCompletedLists.firstIndex(where: { $0.swapId == SwapList.swapLists[useIndex].swapId && $0.completedDate == calendarDate }) {
            let completedItem = SwapCompletedList.swapCompletedLists[compltedIndexes]
            cell.checkButton.isSelected = completedItem.isCompleted
        } else {
            SwapCompletedList.addToUpdate(swapId: SwapList.swapLists[useIndex].swapId, completedDate: calendarDate, isCompleted: false)
            self.mainTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let useCount = SwapList.swapLists.filter{ $0.isDateCheck }.count
        return useCount > 0 ? useCount : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let useIndexes = SwapList.swapLists.enumerated().filter { $0.element.isDateCheck }.map { $0.offset }
        
        if useIndexes.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewNoneCell.identifier, for: indexPath) as? MainTableViewNoneCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        } else {
            let useIndex = useIndexes[indexPath.row]
            let item = SwapList.swapLists[useIndex]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.titleLabel.text = item.title
            compltedUpdate(cell, useIndex)
            cell.checkButton.tag = useIndex
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !SwapList.swapLists.isEmpty {
            if let recordVC = storyboard?.instantiateViewController(withIdentifier: "RecordViewController") as? RecordViewController {
                let useIndexes = SwapList.swapLists.enumerated().filter { $0.element.isDateCheck }.map { $0.offset }
                let useIndex = useIndexes[indexPath.row]
                recordVC.swapId = SwapList.swapLists[useIndex].swapId
                recordVC.swapTitle = SwapList.swapLists[useIndex].title
                recordVC.startDate = SwapList.swapLists[useIndex].startDate
                recordVC.endDate = SwapList.swapLists[useIndex].endDate
                recordVC.selectedDate = calendarDate
                present(recordVC, animated: true)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
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
        calendarHeader.text = DateFormatter().displayDateFormatter.string(from: currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarDate = date
        SwapList.isSwapInRange(target: calendarDate)
        self.mainTableView.reloadData()
        calendarHeader.text = DateFormatter().displayDateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        if day == 0 {
            return .systemRed
        } else {
            return .swapTextColor
        }
    }
}

extension MainViewController: FSCalendarDataSource {}

class MainTableViewCell: UITableViewCell {
    static let identifier = "MainTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
}

class MainTableViewNoneCell: UITableViewCell {
    static let identifier = "MainTableViewNoneCell"
}

extension MainViewController: SwapDataDelegate {
    func reloadData() {
        self.mainTableView.reloadData()
    }
}

