//
//  MainViewController.swift
//  swap
//
//  Created by SUNG on 1/29/24.
//

import UIKit
import FSCalendar
import RealmSwift

//MARK : Protocols
protocol UpdateNickNameDelegate {
    func updateNickName()
}

protocol SwapDataDelegate {
    func reloadData()
}

final class MainViewController: UIViewController {
    // MARK: Properties
    private let swapListRepository = SwapListRepository()
    private let swapCompletedListRepository = SwapCompletedListRepository()
    private let swapRecordRepository = SwapRecordRepository()
    
    // MARK: Outlets
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var weekCalendar: FSCalendar!
    @IBOutlet weak var calendarHeader: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    private var calendarDate = Date()
    
//    let headerDateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy년 MM월"
//        return formatter
//    }()
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        configureKeyboard()
        configureWeekCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nickName = fetchNickName() {
            nicknameLabel.text = "\(nickName)님"
        }
        
        swapListRepository.isSwapInRange(target: calendarDate)
        self.mainTableView.reloadData()
        weekCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .systemRed
    }
    
    // MARK: Configure
    private func configureKeyboard() {
        hideKeyboardWhenTappedAround()
        dismissKeyboard()
    }
    
    private func configureWeekCalendar() {
        weekCalendar.dataSource = self
        weekCalendar.delegate = self
        
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
        weekCalendar.appearance.selectionColor = .systemRed
        
        calendarHeader.text = DateFormatter().displayDateFormatter.string(from: Date())
        weekCalendar.select(calendarDate)
        
        if let selectedDate = weekCalendar.selectedDate {
            calendarDate = selectedDate
        }
    }
    
    // MARK: Functions
    func fetchNickName() -> String? {
        return UserDefaults.standard.string(forKey: "nickname")
    }
    
    private func presentTabBar(withIdentifier identifier: String) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false)
        }
    }
    
    /// - NOTE: UserDefaults를 삭제하는 코드
    // func clearUserDefaultDate() {
        // for key in UserDefaults.standard.dictionaryRepresentation().keys {
        //     UserDefaults.standard.removeObject(forKey: key.description)
        // }
    // }
    
    // MARK: Actions
    @IBAction func calendarAddButtonClicked(_ sender: UIButton) {
        guard let calendarAddVC = storyboard?.instantiateViewController(withIdentifier: "CalendarAddViewController") as? CalendarAddViewController else { return }
        calendarAddVC.currentDate = calendarDate
        calendarAddVC.swapDataDelegate = self
        present(calendarAddVC, animated: true)
    }
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        guard let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingModalViewController") as? SettingModalViewController else { return }
        settingVC.UpdateNickNameDelegate = self
        present(settingVC, animated: true)
    }
    
    @IBAction func checkButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        swapCompletedListRepository.addToUpdate(SwapCompletedList(swapId: sender.tag, completedDate: calendarDate, isCompleted: sender.isSelected))
    }
}

//MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func compltedUpdate(_ cell: MainTableViewCell, _ useIndex: Int) {
        if let completedItem = swapCompletedListRepository.completeCheckfilter(useIndex, calendarDate).first {
            cell.checkButton.isSelected = completedItem.isCompleted
        } else {
            swapCompletedListRepository.addToUpdate(SwapCompletedList(swapId: useIndex, completedDate: calendarDate, isCompleted: false))
            self.mainTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let useCount = swapListRepository.dateRangeFilter().count
        return useCount > 0 ? useCount : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datas = swapListRepository.dateRangeFilter()

        if datas.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewNoneCell.identifier, for: indexPath) as? MainTableViewNoneCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)

            let item = datas[indexPath.row]
            cell.titleLabel.text = item.title
            compltedUpdate(cell, item.swapId)
            cell.checkButton.tag = item.swapId
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let datas = swapListRepository.dateRangeFilter()
        if !datas.isEmpty {
            if let recordVC = storyboard?.instantiateViewController(withIdentifier: "RecordViewController") as? RecordViewController {
                let item = datas[indexPath.row]
                recordVC.swapId = item.swapId
                recordVC.swapTitle = item.title
                recordVC.startDate = item.startDate
                recordVC.endDate = item.endDate
                recordVC.selectedDate = calendarDate
                present(recordVC, animated: true)
            }
        }
    }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            let datas = self.swapListRepository.dateRangeFilter()
            self.swapRecordRepository.delete(swapId: datas[indexPath.row].swapId)
            self.swapCompletedListRepository.delete(swapId: datas[indexPath.row].swapId)
            self.swapListRepository.delete(swapId: datas[indexPath.row].swapId)
            self.mainTableView.reloadData()
            success(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
}

// MAKR: UITabBarDelegate
extension MainViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[1] {
            presentTabBar(withIdentifier: "AttaintViewController")
        } else if item == tabBar.items?[2] {
            presentTabBar(withIdentifier: "TrophyViewController")
        }
    }
}

// MARK: FSCalendarDelegate & FSCalendarDelegateAppearance
extension MainViewController: FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = weekCalendar.currentPage
        calendarHeader.text = DateFormatter().displayDateFormatter.string(from: currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarDate = date
        swapListRepository.isSwapInRange(target: calendarDate)
        self.mainTableView.reloadData()
        calendarHeader.text = DateFormatter().displayDateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        return day == 0 ? .systemRed : .swapTextColor
    }
}

// MARK: FSCalendarDataSource
extension MainViewController: FSCalendarDataSource {}

// MARK: SwapDataDelegate
extension MainViewController: SwapDataDelegate {
    func reloadData() {
        self.mainTableView.reloadData()
    }
}

// MARK: UpdateNickNameDelegate
extension MainViewController: UpdateNickNameDelegate {
    func updateNickName() {
        if let nickName = fetchNickName() {
            nicknameLabel.text = "\(nickName)님"
        }
    }
}

