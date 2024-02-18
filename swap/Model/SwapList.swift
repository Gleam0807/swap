//
//  SwapList.swift
//  swap
//
//  Created by SUNG on 2/12/24.
//

import UIKit
import AVFoundation
import UserNotifications

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
    var alramDate: Date?
    var sound = UNMutableNotificationContent()
    
    static func add(title: String, startDate: Date, endDate: Date, isAlarm: Bool, isDateCheck: Bool) {
        autoSwapId += 1
        let newSwap = SwapList(swapId: autoSwapId, title: title, isCompleted: false, startDate: startDate, endDate: endDate, isAlarm: isAlarm, isDateCheck: isDateCheck, alramDate: nil)
        swapLists.append(newSwap)
    }
        
    static func delete(swapId: Int) {
        if let index = swapLists.firstIndex(where: { $0.swapId == swapId }) {
            swapLists.remove(at: index)
        }
    }
    
    static func isSwapInRange(target: Date) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: target)
        
        for i in 0..<SwapList.swapLists.count {
            let swapStartDateComponents = calendar.dateComponents([.year, .month, .day], from: SwapList.swapLists[i].startDate)
            let swapEndDateComponents = calendar.dateComponents([.year, .month, .day], from: SwapList.swapLists[i].endDate)
            if let date = calendar.date(from: dateComponents),
               let swapStartDate = calendar.date(from: swapStartDateComponents),
               let swapEndDate = calendar.date(from: swapEndDateComponents) {
                if date >= swapStartDate && date <= swapEndDate {
                    SwapList.swapLists[i].isDateCheck = true
                } else {
                    SwapList.swapLists[i].isDateCheck = false
                }
            }
        }
    }
    
    init(swapId: Int, title: String, isCompleted: Bool, startDate: Date, endDate: Date, isAlarm: Bool, isDateCheck: Bool, alramDate: Date?) {
        self.swapId = swapId
        self.title = title
        self.isCompleted = isCompleted
        self.startDate = startDate
        self.endDate = endDate
        self.isAlarm = isAlarm
        self.isDateCheck = isDateCheck
        self.alramDate = alramDate
    }
}
