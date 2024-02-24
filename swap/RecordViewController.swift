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
    let swapCompletedListRepository = SwapCompletedListRepository()
    let swapRecordRepository = SwapRecordRepository()
    //MARK: Outlet
    @IBOutlet weak var monthCalendar: FSCalendar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressStartDateLabel: UILabel!
    @IBOutlet weak var progressEndDateLabel: UILabel!
    
    var swapId: Int?
    var swapTitle: String?
    var startDate: Date?
    var endDate: Date?
    var selectedDate: Date?
    var itemProviders: [NSItemProvider] = []
    var imageArray: [UIImage] = []
    var imageData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthCalendar.dataSource = self
        monthCalendar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        memoTextView.delegate = self
        
        monthCalendar.appearance.headerMinimumDissolvedAlpha = 0
        monthCalendar.rowHeight = 30
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
        progressSetting()
    
        // 선택된 날짜 정보에 header에 표시
        if let selectedDate = selectedDate {
            let headerText = DateFormatter().recordDisplayDateFormatter.string(from: selectedDate)
            monthCalendar.appearance.headerDateFormat = headerText
            monthCalendar.select(selectedDate)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = swapTitle
        if let swapId = swapId, let swapRecord = swapRecordRepository.selectedDateEqualToRecordedDate(swapId, selectedDate ?? Date()).first, !swapRecord.memo.isEmpty {
            memoTextView.text = swapRecord.memo
            memoTextView.textColor = .swapTextColor
        } else {
            memoTextView.text = "메모"
            memoTextView.textColor = .lightGray
        }
        monthCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    func progressSetting() {
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 0.8)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        if let startDate = startDate, let endDate = endDate, let swapId = swapId {
            let calendar = Calendar.current
            progressStartDateLabel.text = "\(DateFormatter().recordProgressDateFormatter.string(from:startDate))"
            progressEndDateLabel.text = "\(DateFormatter().recordProgressDateFormatter.string(from:endDate))"
            let totalDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
            guard let completedCount = swapCompletedListRepository.completeCountfilter(swapId) else { return }
            
            let progress = Float(completedCount) / Float(totalDays)
            //let progressPercentage = Int(progress * 100)
            progressView.setProgress(progress, animated: true)
        }
    }
    
    func showImage(for cell: CollectionViewCell) {
        // 이미지를 표시할 UIImageView 배열
        let imageViews = [cell.firstImage, cell.secondImage, cell.thirdImage, cell.fourthImage]

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
            return
        }
        
        for image in imageArray {
            if let data = image.jpegData(compressionQuality: 0.8) {
                imageData.append(data)
            }
        }
        
        if swapRecordRepository.isDuplicate(swapId: swapId, recordDate: selectedDate) {
            swapRecordRepository.update(swapId: swapId, recordDate: selectedDate, memo: memo, images: imageArray)
        } else {
            swapRecordRepository.add(SwapRecord(recordDate: selectedDate, swapId: swapId, title: title, startDate: startDate, endDate: endDate, memo: memo, images: imageData))
        }
        self.dismiss(animated: true)
    }
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
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
            textView.textColor = .swapTextColor
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
        if let swapId = swapId {
            let imageData = swapRecordRepository.fetchImages(swapId: swapId, recordDate: selectedDate ?? Date())
            if !imageData.isEmpty {
                // 이미지 뷰들을 순회하면서 이미지를 설정
                let imageViews = [cell.firstImage, cell.secondImage, cell.thirdImage, cell.fourthImage]
                for (index, imageView) in imageViews.enumerated() {
                    guard index < imageData.count else { break }
                    if let image = UIImage(data: imageData[index]) {
                        imageView?.image = image
                    }
                }
            }
        } else {
            // 이미지가 없는 경우 이미지 뷰를 초기화
            cell.secondImage.image = nil
            cell.thirdImage.image = nil
            cell.fourthImage.image = nil
        }
        // UIImage 배열에 있는 이미지를 UIImageView에 설정
//        if let swapId = swapId, let selectedDate = selectedDate {
//            for (index, image) in swapRecordRepository.fetchImages(swapId: swapId, recordDate: selectedDate).enumerated() {
//                if index < imageViews.count {
//                    imageViews[index]?.image = image
//                }
//            }
//        } 수정필요
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

extension RecordViewController: FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = monthCalendar.currentPage
        if let selectedDate = selectedDate {
            let currentPageMonth = DateFormatter().displayDateFormatter.string(from: currentPage)
            let seletedPageMonth = DateFormatter().displayDateFormatter.string(from: selectedDate)
            if currentPageMonth == seletedPageMonth {
                let headerText = DateFormatter().recordDisplayDateFormatter.string(from: selectedDate)
                monthCalendar.appearance.headerDateFormat = headerText
            } else {
                let headerText = DateFormatter().recordDisplayDateFormatter.string(from: currentPage)
                monthCalendar.appearance.headerDateFormat = headerText
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let eventScaleFactor: CGFloat = 7.0
        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
        //cell.eventIndicator.color = UIColor.swapButtonColor?.withAlphaComponent(0.85)
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }

}

extension RecordViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if let startDate = startDate, let endDate = endDate {
            if date >= startDate, date <= endDate {
                return 1
            }
        }
        return 0
    }
}

extension RecordViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        if day == 0 {
            return .systemRed
        } else {
            return .swapTextColor
        }
    }
}

