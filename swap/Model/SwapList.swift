//
//  SwapList.swift
//  swap
//
//  Created by SUNG on 2/12/24.
//

import UIKit

struct SwapList {
    static var swapLists = [SwapList]()
    static var autoSwapId: Int = swapLists.count
    
    var swapId: Int
    var title: String
    var isCompleted: Bool
    var startDate: Date
    var endDate: Date
    var isAlarm: Bool
    var isDateCheck: Bool
    
    static func add(title: String, startDate: Date, endDate: Date, isAlarm: Bool) {
        autoSwapId += 1
        let newSwap = SwapList(swapId: autoSwapId, title: title, isCompleted: false, startDate: startDate, endDate: endDate, isAlarm: isAlarm, isDateCheck: false)
        swapLists.append(newSwap)
    }
    
    init(swapId: Int, title: String, isCompleted: Bool, startDate: Date, endDate: Date, isAlarm: Bool, isDateCheck: Bool) {
        self.swapId = swapId
        self.title = title
        self.isCompleted = isCompleted
        self.startDate = startDate
        self.endDate = endDate
        self.isAlarm = isAlarm
        self.isDateCheck = isDateCheck
    }
}
