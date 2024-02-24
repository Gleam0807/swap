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
    func fetchImages(swapId: Int, recordDate: Date) -> [Data]
}

class SwapRecordRepository: SwapRecordRepositoryType {
    let realm = try! Realm()
    
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
                var imageData = Data()
                for image in images {
                    if let data = image.jpegData(compressionQuality: 0.8) {
                        imageData.append(data)
                    }
                }
                swapRecord.images = imageData
            }
            swapRecord.memo = memo
        }
    }
    
    func selectedDateEqualToRecordedDate(_ swapId: Int, _ selectedDate: Date) -> [SwapRecord] {
        return Array(realm.objects(SwapRecord.self).filter("swapId == %@ AND recordDate == %@", swapId, selectedDate))
    }
    
    func fetchImages(swapId: Int, recordDate: Date) -> [Data] {
        var images: [Data] = []
        let storedImages = realm.objects(SwapRecord.self).filter("swapId == %@ AND recordDate == %@", swapId, recordDate)
        
        // Results 객체가 비어 있는지 확인
        if !storedImages.isEmpty {
            print(storedImages)
            
            // Results 객체에서 각 SwapRecord의 이미지 데이터를 가져와 배열에 추가
            for record in storedImages {
                if let imageData = record.images {
                    print(imageData)
                    images.append(imageData)
                }
            }
        }
        
        return images
    }
    
}
