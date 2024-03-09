////
////  SwapList.swift
////  swap
////
////  Created by SUNG on 2/12/24.
////
//
//import UIKit
//import AVFoundation
//import UserNotifications
//
//struct SwapList {
//    static var swapLists = [SwapList]()
//    static var autoSwapId: Int = swapLists.count
//    
//    var swapId: Int
//    var title: String
//    var isCompleted: Bool
//    var startDate: Date
//    var endDate: Date
//    var isAlarm: Bool
//    var isDateCheck: Bool
//    var alramDate: Date?
//    
//    static func add(title: String, startDate: Date, endDate: Date, isAlarm: Bool, isDateCheck: Bool) {
//        autoSwapId += 1
//        let newSwap = SwapList(swapId: autoSwapId, title: title, isCompleted: false, startDate: startDate, endDate: endDate, isAlarm: isAlarm, isDateCheck: isDateCheck, alramDate: nil)
//        swapLists.append(newSwap)
//    }
//        
//    static func delete(swapId: Int) {
//        if let index = swapLists.firstIndex(where: { $0.swapId == swapId }) {
//            swapLists.remove(at: index)
//        }
//    }
//    
//    static func isSwapInRange(target: Date) {
//        let calendar = Calendar.current
//        let dateComponents = calendar.dateComponents([.year, .month, .day], from: target)
//        
//        for i in 0..<SwapList.swapLists.count {
//            let swapStartDateComponents = calendar.dateComponents([.year, .month, .day], from: SwapList.swapLists[i].startDate)
//            let swapEndDateComponents = calendar.dateComponents([.year, .month, .day], from: SwapList.swapLists[i].endDate)
//            if let date = calendar.date(from: dateComponents),
//               let swapStartDate = calendar.date(from: swapStartDateComponents),
//               let swapEndDate = calendar.date(from: swapEndDateComponents) {
//                if date >= swapStartDate && date <= swapEndDate {
//                    SwapList.swapLists[i].isDateCheck = true
//                } else {
//                    SwapList.swapLists[i].isDateCheck = false
//                }
//            }
//        }
//    }
//    
//    static func scheduleNotification(title: String, seletedTimeDate: Date, identifierCnt: Int) {
//        let content = UNMutableNotificationContent()
//        content.title = "Swap 알림"
//        content.body = "\(title)를 실천하실 시간이에요🙌"
//        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Clock.mp3"))
//        let calendar = Calendar.current
//        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: seletedTimeDate)
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //테스트용
//        let request = UNNotificationRequest(identifier: "SwapAlarm_\(identifierCnt)", content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Notification Error: ", error)
//            }
//        }
//    }
//    
//    static func scheduleNotificationsForRange(title: String, startDate: Date, endDate: Date, selectedTimeDate: Date) {
//        let calendar = Calendar.current
//        var alarmDate = startDate
//        var identifierCnt = 1
//        // startDate부터 endDate까지 반복하면서 알림 예약
//        while alarmDate <= endDate {
//            let notificationTime = calendar.date(bySettingHour: calendar.component(.hour, from: selectedTimeDate), minute: calendar.component(.minute, from: selectedTimeDate), second: 0, of: alarmDate)!
//            scheduleNotification(title: title, seletedTimeDate: notificationTime, identifierCnt: identifierCnt)
//
//            // 다음 날짜로 설정
//            alarmDate = calendar.date(byAdding: .day, value: 1, to: alarmDate)!
//            identifierCnt += 1
//        }
//    }
//    
//    init(swapId: Int, title: String, isCompleted: Bool, startDate: Date, endDate: Date, isAlarm: Bool, isDateCheck: Bool, alramDate: Date?) {
//        self.swapId = swapId
//        self.title = title
//        self.isCompleted = isCompleted
//        self.startDate = startDate
//        self.endDate = endDate
//        self.isAlarm = isAlarm
//        self.isDateCheck = isDateCheck
//        self.alramDate = alramDate
//    }
//}
