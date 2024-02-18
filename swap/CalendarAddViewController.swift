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
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var alramSeleted: UIButton!
    var alramDropDownTableView: UITableView!
    let options = ["미사용", "사용"]
    var isDropdownShow = false
    var isAlram = false
    var currentDate: Date?
    
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    var monthCalendar: FSCalendar!
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
     }()
    
    var swapDataDelegate: SwapDataDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monthCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    //MARK: function
    func setupViews() {
        // 알람 드랍다운 생성 및 설정
        alramDropDownTableView = UITableView()
        alramDropDownTableView.dataSource = self
        alramDropDownTableView.delegate = self
        alramDropDownTableView.isHidden = true
        view.addSubview(alramDropDownTableView)
        
        alramDropDownTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alramDropDownTableView.topAnchor.constraint(equalTo: alramSeleted.bottomAnchor, constant: -5),
            alramDropDownTableView.leadingAnchor.constraint(equalTo: alramSeleted.leadingAnchor),
            alramDropDownTableView.widthAnchor.constraint(equalTo: alramSeleted.widthAnchor),
            alramDropDownTableView.heightAnchor.constraint(equalToConstant: 80)
        ])
        alramDropDownTableView.backgroundColor = .swapInputColor
        alramDropDownTableView.layer.masksToBounds = true
        alramDropDownTableView.separatorStyle = .singleLine
        alramDropDownTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
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
        monthCalendar.appearance.selectionColor = .red
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if startDateButton.isSelected {
            selectedStartDate = date
            startDateButton.setTitle(dateFormatter.string(from: date), for: .normal)
            startDateButton.titleLabel?.font = .swapTextFont
        } else if endDateButton.isSelected {
            selectedEndDate = date
            endDateButton.setTitle(dateFormatter.string(from: date), for: .normal)
            endDateButton.titleLabel?.font = .swapTextFont
        }
        calendar.isHidden = true
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        print(day)
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        } else {
            return .swapTextColor
        }
    }
    
    //MARK: Action
    @IBAction func alramseletedButtonClicked(_ sender: UIButton) {
        isDropdownShow.toggle()
        alramDropDownTableView.isHidden = !isDropdownShow
    }
    @IBAction func alarmButtonClicked(_ sender: UIButton) {        
        if isAlram {
            if let alarmVC = storyboard?.instantiateViewController(withIdentifier: "AlarmModalViewController") {
                alarmVC.modalPresentationStyle = .overFullScreen
                present(alarmVC, animated: true)
            }
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
    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let title = titleLabel.text, !title.isEmpty,
              let startDate = selectedStartDate,
              let endDate = selectedEndDate
        else {
            let alert = UIAlertController(title: "올바르지 않은 정보", message: "습관명을 입력해주세요.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard startDate <= endDate else {
            let alert = UIAlertController(title: "올바르지 않은 날짜", message: "시작일이 종료일보다 이전이어야 합니다.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if let currentDate = currentDate {
            let isDateInRange = isDateInRange(startDate: startDate, endDate: endDate, target: currentDate)
            SwapList.add(title: title, startDate: startDate, endDate: endDate, isAlarm: isAlram, isDateCheck: isDateInRange)
        } else {
            SwapList.add(title: title, startDate: startDate, endDate: endDate, isAlarm: isAlram, isDateCheck: false)
        }
        
        swapDataDelegate.reloadData()
        self.dismiss(animated: true)
    }
    
    
}

extension CalendarAddViewController: UITableViewDelegate {
    
}

extension CalendarAddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
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
        alramDropDownTableView.isHidden = true
        if options[indexPath.row] == "사용"{
            isAlram = true
        } else {
            isAlram = false
        }
    }
}
