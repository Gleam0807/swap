//
//  CalendarAddViewController.swift
//  swap
//
//  Created by SUNG on 1/30/24.
//

import UIKit
import FSCalendar

protocol AlarmVCDataDelegate {
    func alarmDateSet(alarmTime: Date)
}

class CalendarAddViewController: UIViewController {
    // MARK: Properties
    var swapDataDelegate: SwapDataDelegate!
    var currentDate: Date?
    
    private let swapListRepository = SwapListRepository()
    private let options = ["미사용", "사용"]
    private var isDropdownShow = false
    private var isAlram = false
    /// alram 설정 날짜
    private var seletedTimeDate: Date!
    /// 습관 시작 날짜
    private var selectedStartDate: Date?
    /// 습관 끝 날짜
    private var selectedEndDate: Date?
    
    // MARK: UI
    private var alarmDropDownTableView: UITableView!
    private var monthCalendar: FSCalendar!
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var alramSeleted: UIButton!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        dismissKeyboard()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        monthCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .systemRed
    }
    
    // MARK: Configure
    func setupViews() {
        // 알람 드랍다운 생성 및 설정
        alarmDropDownTableView = UITableView()
        alarmDropDownTableView.dataSource = self
        alarmDropDownTableView.delegate = self
        alarmDropDownTableView.isHidden = true
        view.addSubview(alarmDropDownTableView)
        
        alarmDropDownTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmDropDownTableView.topAnchor.constraint(equalTo: alramSeleted.bottomAnchor, constant: -5),
            alarmDropDownTableView.leadingAnchor.constraint(equalTo: alramSeleted.leadingAnchor),
            alarmDropDownTableView.widthAnchor.constraint(equalTo: alramSeleted.widthAnchor),
            alarmDropDownTableView.heightAnchor.constraint(equalToConstant: 80)
        ])
        alarmDropDownTableView.backgroundColor = .swapInputColor
        alarmDropDownTableView.layer.masksToBounds = true
        alarmDropDownTableView.separatorStyle = .singleLine
        alarmDropDownTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // FSCalendar 생성 및 설정
        monthCalendar = FSCalendar(frame: CGRect(x: startDateButton.frame.minX, y: startDateButton.frame.maxY + 230, width: 200, height: 200))

        monthCalendar.backgroundColor = .swapInputColor
        monthCalendar.layer.cornerRadius = 20
        monthCalendar.layer.masksToBounds = true
        monthCalendar.isHidden = true
        monthCalendar.delegate = self
        monthCalendar.dataSource = self
        
        monthCalendar.appearance.headerMinimumDissolvedAlpha = 0
        monthCalendar.rowHeight = 20
        monthCalendar.appearance.titleTodayColor = .swapTextColor
        monthCalendar.appearance.todayColor = .clear
        monthCalendar.appearance.selectionColor = .systemRed
        monthCalendar.placeholderType = .none
        monthCalendar.locale = Locale(identifier: "ko_kr")
        monthCalendar.appearance.headerDateFormat = "YYYY년 MM월 dd일"
        monthCalendar.appearance.headerTitleFont = .swapTextFont
        monthCalendar.appearance.headerTitleColor = .swapTextColor
        monthCalendar.appearance.weekdayFont = .swapTextFont
        monthCalendar.appearance.weekdayTextColor = .swapTextColor
        monthCalendar.appearance.titleFont = .swapTextFont
        monthCalendar.appearance.titleDefaultColor = .swapTextColor
        monthCalendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        view.addSubview(monthCalendar)
    }
    
    //MARK: Action
    @IBAction func alramseletedButtonClicked(_ sender: UIButton) {
        isDropdownShow.toggle()
        alarmDropDownTableView.isHidden = !isDropdownShow
    }
    
    @IBAction func alarmButtonClicked(_ sender: UIButton) {
        if isAlram {
            guard let alarmVC = storyboard?.instantiateViewController(withIdentifier: "AlarmModalViewController") as? AlarmModalViewController else { return }
            alarmVC.modalPresentationStyle = .overFullScreen
            alarmVC.alarmVCDataDelegate = self
            present(alarmVC, animated: true)
        }
    }
    
    @IBAction func startCalendarHidden(_ sender: UIButton) {
        monthCalendar.frame = CGRect(x: sender.frame.minX, y: sender.frame.maxY + 235, width: 200, height: 200)
        monthCalendar.isHidden = !monthCalendar.isHidden
        sender.isSelected = !monthCalendar.isHidden
        endDateButton.isSelected = false
    }
    
    @IBAction func endCalendarHidden(_ sender: UIButton) {
        monthCalendar.frame = CGRect(x: sender.frame.minX, y: sender.frame.maxY + 305, width: 200, height: 200)
        monthCalendar.isHidden = !monthCalendar.isHidden
        sender.isSelected = !monthCalendar.isHidden
        startDateButton.isSelected = false
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard 
            let title = titleLabel.text,
            !title.isEmpty,
            let startDate = selectedStartDate,
            let endDate = selectedEndDate
        else {
            presentAlert(title: "올바르지 않은 정보", message: "습관명을 입력해주세요.")
            return
        }
        
        guard startDate <= endDate else {
            presentAlert(title: "올바르지 않은 날짜", message: "시작일이 종료일보다 이전이어야 합니다.")
            return
        }
        
        if let currentDate = currentDate {
            let isDateInRange = isDateInRange(startDate: startDate, endDate: endDate, target: currentDate)
            swapListRepository.add(SwapList(title: title, startDate: startDate, endDate: endDate, isAlarm: isAlram, isDateCheck: isDateInRange))
        } else {
            swapListRepository.add(SwapList(title: title, startDate: startDate, endDate: endDate, isAlarm: isAlram, isDateCheck: false))
        }
        
        swapDataDelegate.reloadData()
        
        if isAlram {
            swapListRepository.scheduleNotificationsForRange(title: title, startDate: startDate, endDate: endDate, selectedTimeDate: seletedTimeDate)
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: UITableViewDelegate
extension CalendarAddViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDataSource
extension CalendarAddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell") ?? UITableViewCell(style: .default, reuseIdentifier: "DropdownCell")
        let selectedBackgroundView = UIView()
        cell.backgroundColor = .swapInputColor
        cell.textLabel?.font = .swapTextFont
        cell.textLabel?.textAlignment = .center
        selectedBackgroundView.backgroundColor = .swapButtonColor
        cell.selectedBackgroundView = selectedBackgroundView
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alramSeleted.setTitle(options[indexPath.row], for: .normal)
        isDropdownShow = false
        alarmDropDownTableView.isHidden = true
        if options[indexPath.row] == "사용"{
            isAlram = true
        } else {
            isAlram = false
        }
    }
}

// MARK: FSCalendarDelegate
extension CalendarAddViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if startDateButton.isSelected {
            selectedStartDate = date
            startDateButton.setTitle(DateFormatter().calendarDisplayDateFormatter.string(from: date), for: .normal)
            startDateButton.titleLabel?.font = .swapTextFont
        } else if endDateButton.isSelected {
            selectedEndDate = date
            endDateButton.setTitle(DateFormatter().calendarDisplayDateFormatter.string(from: date), for: .normal)
            endDateButton.titleLabel?.font = .swapTextFont
        }
        calendar.isHidden = true
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        let isDay = Calendar.current.shortWeekdaySymbols[day] == "일"
        return isDay ? .systemRed : .swapTextColor
    }
}

extension CalendarAddViewController: FSCalendarDataSource {}

// MARK: AlarmVCDataDelegate
extension CalendarAddViewController: AlarmVCDataDelegate {
    func alarmDateSet(alarmTime: Date) {
        seletedTimeDate = alarmTime
    }
}
