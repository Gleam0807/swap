//
//  SwapRecordRepository.swift
//  swap
//
//  Created by SUNG on 2/24/24.
//

import Foundation
import PhotosUI
import RealmSwift

protocol SwapRecordRepositoryType {
    func incrementID() -> Int
    func add(_ swapRecord: SwapRecord)
    func isDuplicate(swapId: Int, recordDate: Date) -> Bool
    func update(swapId: Int, recordDate: Date, memo: String, images: [UIImage])
    func selectedDateEqualToRecordedDate(_ swapId: Int, _ selectedDate: Date) -> [SwapRecord]
    func fetchImages(swapId: Int, recordDate: Date) -> [Data?]
}

class SwapRecordRepository: SwapRecordRepositoryType {
    let realm = try! Realm(configuration: config)
    
    func incrementID() -> Int {
        return (realm.objects(SwapRecord.self).max(ofProperty: "recordId") as Int? ?? 0) + 1
    }
    
    func add(_ swapRecord: SwapRecord) {
        try! realm.write {
            swapRecord.recordId = incrementID()
            realm.add(swapRecord)
        }
    }
    
    func isDuplicate(swapId: Int, recordDate: Date) -> Bool {
        let results = realm.objects(SwapRecord.self).filter("swapId == %@ AND recordDate == %@", swapId, recordDate)
        return !results.isEmpty
    }
    
    func update(swapId: Int, recordDate: Date, memo: String, images: [UIImage]) {
        guard let swapRecord = realm.objects(SwapRecord.self).filter("swapId == %@ AND recordDate == %@", swapId, recordDate).first else {
            return
        }
        try! realm.write {
            // 이미지 데이터를 Data로 변환하여 swapRecord의 imagesData에 저장
            if !images.isEmpty {
                for (index, image) in images.prefix(4).enumerated() {
                    let imageData = image.jpegData(compressionQuality: 0.8)
                    switch index {
                        case 0: swapRecord.firstImage = imageData
                        case 1: swapRecord.secondImage = imageData
                        case 2: swapRecord.thirdImage = imageData
                        case 3: swapRecord.fourthImage = imageData
                        default: break
                    }
                }
            }
            swapRecord.memo = memo
        }
    }
    
    func selectedDateEqualToRecordedDate(_ swapId: Int, _ selectedDate: Date) -> [SwapRecord] {
        return Array(realm.objects(SwapRecord.self).filter("swapId == %@ AND recordDate == %@", swapId, selectedDate))
    }
    
    func fetchImages(swapId: Int, recordDate: Date) -> [Data?] {
        guard let storedRecord = realm.objects(SwapRecord.self)
                                     .filter("swapId == %@ AND recordDate == %@", swapId, recordDate)
                                     .first else {
            return []
        }
        
        // SwapRecord 객체의 이미지 데이터를 배열로 반환
        return [storedRecord.firstImage, storedRecord.secondImage, storedRecord.thirdImage, storedRecord.fourthImage]
    }
    
}
