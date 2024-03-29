//
//  SwapCompletedListRepository.swift
//  swap
//
//  Created by SUNG on 2/24/24.
//

import Foundation
import RealmSwift

protocol SwapCompletedListRepositoryType {
    func incrementID() -> Int
    func fetch() -> [SwapCompletedList]
    func addToUpdate(_ swapCompletedLists: SwapCompletedList)
    func delete(swapId: Int)
    func completeCheckfilter(_ swapId: Int, _ completedDate: Date) -> [SwapCompletedList]
    func completeCountfilter(_ swapId: Int) -> Int?
    func completedfilter(_ swapId: Int, year: Int?, month: Month) -> [Int]
}

class SwapCompletedListRepository: SwapCompletedListRepositoryType {
    let realm = try! Realm()
    
    func incrementID() -> Int {
        return (realm.objects(SwapCompletedList.self).max(ofProperty: "swapCompletedId") as Int? ?? 0) + 1
    }
    
    func fetch() -> [SwapCompletedList] {
        return Array(realm.objects(SwapCompletedList.self))
    }
    
    func addToUpdate(_ swapCompletedList: SwapCompletedList) {
        if let existingSwap = realm.objects(SwapCompletedList.self).filter("swapId == %@ AND completedDate == %@", swapCompletedList.swapId, swapCompletedList.completedDate).first {
            try! realm.write {
                existingSwap.isCompleted = swapCompletedList.isCompleted
            }
        } else {
            try! realm.write {
                swapCompletedList.swapCompletedId = incrementID()
                realm.add(swapCompletedList)
            }
        }
    }
    
    func delete(swapId: Int) {
        if let swapToDelete = realm.objects(SwapCompletedList.self).filter("swapId == %@", swapId).first {
            try! realm.write {
                realm.delete(swapToDelete)
            }
        }
    }
    
    func completeCheckfilter(_ swapId: Int, _ completedDate: Date) -> [SwapCompletedList] {
        let results = Array(realm.objects(SwapCompletedList.self).filter("swapId == %@ AND completedDate == %@", swapId, completedDate))
        return results
    }
    
    func completeCountfilter(_ swapId: Int) -> Int? {
        return Array(realm.objects(SwapCompletedList.self).filter("swapId == %@ AND isCompleted == true", swapId)).count
    }
    
    func completedfilter(_ swapId: Int, year: Int?, month: Month) -> [Int] {
        guard let viewYear = year else { return [] }
        let currentYear = Calendar.current.component(.year, from: Date())
        var realViewYear = viewYear
        
        if currentYear != viewYear {
            realViewYear -= 1
        }
        
        let monthString = String(format: "%02d", month.rawValue)
        let targetDateString = "\(realViewYear)\(monthString)"
        
        var dayLists: [Int] = []
        let completedLists = realm.objects(SwapCompletedList.self)
            .filter("swapId == %@ AND isCompleted == true ", swapId)
        
        // filter를 만족하는 모든 completedList에 대해 반복합니다.
        for completedList in completedLists {
            // Date를 Int로 변환하여 일자만 가져와서 배열에 추가합니다.
            let dateString = "\(completedList.completedDate)"
            let replaceDate = dateString.replacingOccurrences(of: "-", with: "")
            let startIndex = replaceDate.index(replaceDate.startIndex, offsetBy: 6)
            let substring = replaceDate[..<startIndex]
            
            if substring == targetDateString {
                let day = Calendar.current.component(.day, from: completedList.completedDate)
                dayLists.append(day)
            }
        }
        
        return dayLists
    }
}

