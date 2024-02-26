//
//  AttaintViewController.swift
//  swap
//
//  Created by SUNG on 2/1/24.
//

import UIKit
import FSCalendar

enum Metric {
    static var completedViewHeight: CGFloat = 108
    static let collectionViewHeight: CGFloat = 90
    static let cellWidth: CGFloat = UIScreen.main.bounds.width
}

class AttaintViewController: UIViewController {
    let swapListRepository = SwapListRepository()
    let swapCompletedListRepository = SwapCompletedListRepository()
    
    let currentYear = Calendar.current.component(.year, from: Date())
    var yearList: [String] = []
    var viewYear: Int?
    var selectedMonth: String?
    //MARK: Outlet
    let calendarView = CalendarView()
    let calendarCollectionViewCell = CalendarCollectionViewCell()
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var calendarTopView: UIView!
    @IBOutlet weak var attaintTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalendarViewConstraints()
        configureCalendar()
        tabBar.delegate = self
        attaintTableView.dataSource = self
        attaintTableView.delegate = self
        
        scrollToIndex(index: 1)
    }
    
    //MARK: Function
    func scrollToIndex(index: Int) {
        let newIndex = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.async { [weak self] in
            self?.calendarView.collectionView.scrollToItem(at: newIndex, at: .bottom, animated: false)
        }
     }
    
    func setCalendarViewConstraints() {
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
    
    func presentTabBar(withIdentifier identifier: String) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[0] {
            presentTabBar(withIdentifier: "MainViewController")
        } else if item == tabBar.items?[1] {
            
        } else if item == tabBar.items?[2] {
            presentTabBar(withIdentifier: "TrophyViewController")
        }
    }
    
    @objc func janButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)01"
        }
        Metric.completedViewHeight = 108
        attaintTableView.reloadData()
    }
    @objc func febButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)02"
        }
        Metric.completedViewHeight = 90
        attaintTableView.reloadData()
    }
    @objc func marButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)03"
        }
        Metric.completedViewHeight = 108
        attaintTableView.reloadData()
    }
    @objc func aprButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)04"
        }
        Metric.completedViewHeight = 90
        attaintTableView.reloadData()
    }
    @objc func mayButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)05"
        }
        Metric.completedViewHeight = 108
        attaintTableView.reloadData()
    }
    @objc func junButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)06"
        }
        Metric.completedViewHeight = 90
        attaintTableView.reloadData()
    }
    @objc func julButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)07"
        }
        Metric.completedViewHeight = 108
        attaintTableView.reloadData()
    }
    @objc func augButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)08"
        }
        Metric.completedViewHeight = 108
        attaintTableView.reloadData()
    }
    @objc func sepButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)09"
        }
        Metric.completedViewHeight = 90
        attaintTableView.reloadData()
    }
    @objc func octButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)10"
        }
        Metric.completedViewHeight = 108
        attaintTableView.reloadData()
    }
    @objc func novButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)11"
        }
        Metric.completedViewHeight = 90
        attaintTableView.reloadData()
    }
    @objc func decButtonClicked() {
        if var viewYear = viewYear {
            if currentYear != viewYear {
                viewYear = viewYear - 1
            }
            selectedMonth = "\(viewYear)12"
        }
        Metric.completedViewHeight = 108
        attaintTableView.reloadData()
    }
    
    func DaysCalc() -> Int {
        var daysInMonth = 31
        guard let selectedMonth = selectedMonth?.suffix(2) else { return 0 }
    
        switch selectedMonth {
        case "01", "03", "05", "07", "08", "10", "12":
            daysInMonth = 31
        case "04", "06", "09", "11":
            daysInMonth = 30
        case "02":
            if currentYear == viewYear {
                let isLeapYear = (currentYear % 4 == 0 && currentYear % 100 != 0) || currentYear % 400 == 0
                daysInMonth = isLeapYear ? 29 : 28
            }
        default:
            break
        }
        return daysInMonth
    }
}

extension AttaintViewController: UITabBarDelegate {
    
}

extension AttaintViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedMonth = selectedMonth else { return 0 }
        return swapListRepository.dateAttaintRangeFilter(target: selectedMonth).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedMonth = selectedMonth else { return UITableViewCell() }
        let datas = swapListRepository.dateAttaintRangeFilter(target: selectedMonth)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AttaintTableViewCell", for: indexPath) as? AttaintTableViewCell else { return UITableViewCell() }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        print(Metric.completedViewHeight)
        cell.completedView.heightAnchor.constraint(equalToConstant: Metric.completedViewHeight).isActive = true
        let item = datas[indexPath.row]
        cell.titelLabel.text = item.title
        let imageChangedDay = swapCompletedListRepository.completedfilter(item.swapId, selectedMonth)
        let daysMonth = DaysCalc()
        
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
            
            if isFillImage {
                imageView.image = UIImage(systemName: "star.fill")
            } else {
                imageView.image = UIImage(systemName: "star")
            }
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

class AttaintTableViewCell: UITableViewCell {
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var completedView: UIView!
    var imageViews: [UIImageView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageViews()
    }
    
    func setupImageViews() {
        for i in 1...31 {
            if let imageView = self.contentView.viewWithTag(i) as? UIImageView {
                imageViews.append(imageView)
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension AttaintViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yearList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
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
        cell.janButton.addTarget(self, action: #selector(janButtonClicked), for: .touchUpInside)
        cell.febButton.addTarget(self, action: #selector(febButtonClicked), for: .touchUpInside)
        cell.marButton.addTarget(self, action: #selector(marButtonClicked), for: .touchUpInside)
        cell.aprButton.addTarget(self, action: #selector(aprButtonClicked), for: .touchUpInside)
        cell.mayButton.addTarget(self, action: #selector(mayButtonClicked), for: .touchUpInside)
        cell.junButton.addTarget(self, action: #selector(junButtonClicked), for: .touchUpInside)
        cell.julButton.addTarget(self, action: #selector(julButtonClicked), for: .touchUpInside)
        cell.augButton.addTarget(self, action: #selector(augButtonClicked), for: .touchUpInside)
        cell.sepButton.addTarget(self, action: #selector(sepButtonClicked), for: .touchUpInside)
        cell.octButton.addTarget(self, action: #selector(octButtonClicked), for: .touchUpInside)
        cell.novButton.addTarget(self, action: #selector(novButtonClicked), for: .touchUpInside)
        cell.decButton.addTarget(self, action: #selector(decButtonClicked), for: .touchUpInside)
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
