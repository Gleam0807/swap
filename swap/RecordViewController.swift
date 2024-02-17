//
//  RecordViewController.swift
//  swap
//
//  Created by SUNG on 2/2/24.
//

import UIKit
import FSCalendar
import PhotosUI

class RecordViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var monthCalendar: FSCalendar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var swapId: Int?
    var swapTitle: String?
    var startDate: Date?
    var endDate: Date?
    var selectedDate: Date?
    var itemProviders: [NSItemProvider] = []
    var imageArray: [UIImage] = []
    
    override func viewDidLoad() {
        monthCalendar.dataSource = self
        monthCalendar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        memoTextView.delegate = self
        memoTextView.text = "메모"
        memoTextView.textColor = .lightGray
        
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
    
        if let selectedDate = selectedDate {
            print(selectedDate)
            monthCalendar.select(selectedDate, scrollToDate: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = swapTitle
        monthCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    func showImage(for cell: CollectionViewCell) {
        // 이미지를 표시할 UIImageView 배열
        let imageViews = [cell.firstImage, cell.secondImage, cell.thirdImage, cell.fourthImage]

        if !imageArray.isEmpty {
            for (index, image) in imageArray.enumerated() {
                guard index < imageViews.count else { break }
                print(image)
                imageViews[index]?.image = image
            }
        }
        // itemProviders에서 각 이미지를 로드하여 UIImageView에 설정
        for (index, itemProvider) in itemProviders.enumerated() {
            // 이미지를 표시할 UIImageView가 없으면 종료
            guard index < imageViews.count else { break }

            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                  
                    guard let image = image as? UIImage else { return }
                
                    DispatchQueue.main.async {
                        self.imageArray.append(image)
                        imageViews[index]?.image = image
                    }
                }
            }
        }
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let swapId = swapId,
              let title = swapTitle,
              let startDate = startDate,
              let endDate = endDate,
              let selectedDate = selectedDate,
              let memo = memoTextView.text
        else {
            print("빈값존재")
            return
        }
        
        if SwapRecord.isDuplicate(swapId: swapId) {
            SwapRecord.update(swapId: swapId, memo: memo, images: imageArray)
            print(SwapRecord.swapRecords)
            self.dismiss(animated: true)
            return
        }
        
        SwapRecord.add(swapId: swapId, title: title, startDate: startDate, endDate: endDate, recordDate: selectedDate, memo: memo, images: imageArray)
        print(SwapRecord.swapRecords)
        self.dismiss(animated: true)
    }
    
}

extension RecordViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let eventScaleFactor: CGFloat = 7.0
        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
        cell.eventIndicator.color = UIColor(named: "ButtonColor")?.withAlphaComponent(0.85)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for swap in SwapList.swapLists {
            if date >= swap.startDate, date <= swap.endDate {
                return 1
            }
        }
    
        return 0
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        if day == 0 {
            return .systemRed
        } else {
            return UIColor(named: "TextColor")
        }
    }
    
}

extension RecordViewController: PHPickerViewControllerDelegate {
    // picker가 종료되면 동작하는 함수
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // picker 화면에서 내리기
        picker.dismiss(animated: true)
        
        // 만들어준 itemProviders에 Picker로 선택한 이미지정보를 전달
        itemProviders = results.map{ $0.itemProvider }
        collectionView.reloadData()
        
    }
}

extension RecordViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor(named: "TextColor")
        }
    }
}

extension RecordViewController: UICollectionViewDelegate {
    
}

extension RecordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        showImage(for: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 4
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
    
        self.present(imagePicker, animated: true)
    }
    
    
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
}

