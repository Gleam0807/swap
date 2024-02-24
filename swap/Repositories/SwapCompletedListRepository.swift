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
    func completeCheckfilter(_ swapId: Int, _ completedDate: Date) -> [SwapCompletedList]
    func completeCountfilter(_ swapId: Int) -> Int?
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
    
    func completeCheckfilter(_ swapId: Int, _ completedDate: Date) -> [SwapCompletedList] {
        let results = Array(realm.objects(SwapCompletedList.self).filter("swapId == %@ AND completedDate == %@", swapId, completedDate))
        return results
    }
    
    func completeCountfilter(_ swapId: Int) -> Int? {
        return Array(realm.objects(SwapCompletedList.self).filter("swapId == %@ AND isCompleted == true", swapId)).count
    }
}
