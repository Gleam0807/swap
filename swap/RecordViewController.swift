//
//  RecordViewController.swift
//  swap
//
//  Created by SUNG on 2/2/24.
//

import UIKit
import FSCalendar
import PhotosUI

class RecordViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    //MARK: Outlet
    @IBOutlet weak var monthCalendar: FSCalendar!
    @IBOutlet weak var collectionView: UICollectionView!
    var itemProviders: [NSItemProvider] = []

    
    override func viewDidLoad() {
        monthCalendar.dataSource = self
        monthCalendar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monthCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일"
        let headerText = dateFormatter.string(from: date)
        
        calendar.appearance.headerDateFormat = headerText
        monthCalendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date)
        if day == 1 {
            return .red
        } else {
            return UIColor(named: "TextColor")
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
                    print(image)
                    
                    DispatchQueue.main.async {
                        imageViews[index]?.image = image
                    }
                }
            }
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
        
        // 화면에 띄우기
        self.present(imagePicker, animated: true)
    }
    
    
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
}

