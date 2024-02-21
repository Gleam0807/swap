//
//  SwapCompletedList.swift
//  swap
//
//  Created by SUNG on 2/20/24.
//

import UIKit

struct SwapCompletedList {
    static var swapCompletedLists = [SwapCompletedList]()
    static var autoSwapCompletedId: Int = swapCompletedLists.count
    
    var swapId: Int
    var swapCompletedId: Int
    var completedDate: Date
    var isCompleted: Bool
    
    static func addToUpdate(swapId: Int, completedDate: Date, isCompleted: Bool) {
        if let swapIndex = swapCompletedLists.firstIndex(where: { $0.swapId == swapId && $0.completedDate == completedDate }) {
            swapCompletedLists[swapIndex].isCompleted = isCompleted
        } else {
            autoSwapCompletedId += 1
            let newSwap = SwapCompletedList(swapId: swapId, swapCompletedId: autoSwapCompletedId, completedDate: completedDate, isCompleted: isCompleted)
            swapCompletedLists.append(newSwap)
        }
    }
    
    init(swapId: Int, swapCompletedId: Int, completedDate: Date, isCompleted: Bool) {
        self.swapId = swapId
        self.swapCompletedId = swapCompletedId
        self.completedDate = completedDate
        self.isCompleted = isCompleted
    }
}
