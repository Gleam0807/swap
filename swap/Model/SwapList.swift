//
//  SwapList.swift
//  swap
//
//  Created by SUNG on 2/12/24.
//

import UIKit

struct SwapList {
    static var swapLists = [SwapList]()
    static var autoSwapId: Int = 1
    
    var swapId: Int
    var title: String
    var isCompleted: Bool
    var startDate: Date
    var endDate: Date
    var isAlarm: Bool
    
    static func add(title: String, startDate: Date, endDate: Date, isAlarm: Bool) {
        let newSwap = SwapList(swapId: autoSwapId, title: title, isCompleted: false, startDate: startDate, endDate: endDate, isAlarm: isAlarm)
        swapLists.append(newSwap)
        autoSwapId += 1
    }
    
    init(swapId: Int, title: String, isCompleted: Bool, startDate: Date, endDate: Date, isAlarm: Bool) {
        self.swapId = swapId
        self.title = title
        self.isCompleted = isCompleted
        self.startDate = startDate
        self.endDate = endDate
        self.isAlarm = isAlarm
    }
}
