//
//  AttaintViewController.swift
//  swap
//
//  Created by SUNG on 2/1/24.
//

import UIKit
import FSCalendar

enum Month: Int {
    case january = 1
    case febuary
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}

class AttaintViewController: UIViewController {
    // MARK: Enum
    enum Metric {
        static let collectionViewHeight: CGFloat = 90
        static let cellWidth: CGFloat = UIScreen.main.bounds.width
    }
    
    // MARK: Properties
    private let swapListRepository = SwapListRepository()
    private let swapCompletedListRepository = SwapCompletedListRepository()
    
    private let currentYear = Calendar.current.component(.year, from: Date())
    private let monthList: [Month] = [.january, .febuary, .march, .april, .may, .june, .july, .august, .september, .october, .november, .december]
    private var yearList: [String] = []
    private var viewYear: Int?
    private var selectedMonth: Month?
    
    // MARK: UI
    private let calendarView = CalendarView()
    
    // MARK: Outlets
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var calendarTopView: UIView!
    @IBOutlet weak var attaintTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCalndarTopView()
        configureCalendar()
        tabBar.delegate = self
        attaintTableView.dataSource = self
        attaintTableView.delegate = self
    }
    
    // MARK: Configure
    func configureCalndarTopView() {
        calendarTopView.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calendarTopView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarTopView.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: calendarTopView.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendarTopView.bottomAnchor)
        ])
    }
    
    func configureYearList() {
        let range = (currentYear - 100)...(currentYear + 100)
        yearList = Array(range).map { String($0) }
    }
    
    func configureCalendar() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.collectionView.dataSource = self
        calendarView.collectionView.delegate = self
        
        configureYearList()
    }
    
    // MARK: Function
    func presentTabBar(withIdentifier identifier: String) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) else { return }
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false)
    }
    
    // MARK: Actions
    private func daysCalc() -> Int {
        guard let selectedMonth = selectedMonth else { return 0 }
    
        switch selectedMonth {
        case .january, .march, .may, .july, .august, .october, .december:
            return  31
        case .april, .june, .september, .november:
            return 30
        case .febuary:
            if currentYear == viewYear {
                let isLeapYear = (currentYear % 4 == 0 && currentYear % 100 != 0) || currentYear % 400 == 0
                return isLeapYear ? 29 : 28
            } else {
                return 28
            }
        }
    }
    
    private func monthButtonAction(month: Month) {
        selectedMonth = month
        attaintTableView.reloadData()
    }
    
    @objc func monthButtonClicked(sender: UIButton) {
        let month = Month(rawValue: sender.tag) ?? .january
        monthButtonAction(month: month)
    }
}

extension AttaintViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[0] {
            presentTabBar(withIdentifier: "MainViewController")
        } else if item == tabBar.items?[2] {
            presentTabBar(withIdentifier: "TrophyViewController")
        }
    }
}

extension AttaintViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedMonth = selectedMonth else { return 0 }
        return swapListRepository.dateAttaintRangeFilter(year: viewYear, month: selectedMonth).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedMonth = selectedMonth else { return UITableViewCell() }
        let datas = swapListRepository.dateAttaintRangeFilter(year: viewYear, month: selectedMonth)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AttaintTableViewCell", for: indexPath) as? AttaintTableViewCell else { return UITableViewCell() }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        let item = datas[indexPath.row]
        cell.titelLabel.text = item.title
        
        let imageChangedDay = swapCompletedListRepository.completedfilter(item.swapId, year: viewYear, month: selectedMonth)
        let daysMonth = daysCalc()
        
        for (index, imageView) in cell.imageViews.enumerated() {
            var isFillImage = false
            if index < daysMonth {
                for item in imageChangedDay {
                    if (index + 1) == item {
                        isFillImage = true
                        break
                    }
                }
            } else {
                imageView.image = nil
                continue
            }
            
            let imageName = isFillImage ? "star.fill" : "star"
            imageView.image = UIImage(systemName: imageName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
}

extension AttaintViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: UICollectionViewDataSource
extension AttaintViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yearList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calndarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        guard let currentIndex = yearList.firstIndex(of: "\(currentYear)") else { return UICollectionViewCell() }
        let index: Int
        
        if indexPath.item < currentIndex {
            index = indexPath.item + currentIndex
        } else {
            index = indexPath.item - (currentIndex - 1)
        }
        
        let year = yearList[index]
        cell.prepare(year)
        viewYear = Int(year)
        cell.yearLabel.text = "\(year)년"
        
        [cell.janButton, cell.febButton, cell.marButton, cell.aprButton, cell.mayButton, cell.junButton, cell.julButton, cell.augButton, cell.sepButton, cell.octButton, cell.novButton, cell.decButton].forEach {
            $0.addTarget(self, action: #selector(monthButtonClicked(sender:)), for: .touchUpInside)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension AttaintViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let count = yearList.count
        
        if scrollView.contentOffset.x == 0 {
            calendarView.collectionView.setContentOffset(.init(x: Metric.cellWidth * Double(count - 2), y: scrollView.contentOffset.y), animated: false)
        }
        
        if scrollView.contentOffset.x == Double(count - 1) * Metric.cellWidth {
            calendarView.collectionView.setContentOffset(.init(x: Metric.cellWidth, y: scrollView.contentOffset.y), animated: false)
        }
    }
}
