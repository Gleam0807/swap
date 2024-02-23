//
//  SwapListObject.swift
//  swap
//
//  Created by SUNG on 2/23/24.
//

import UIKit
import AVFoundation
import UserNotifications
import RealmSwift

class SwapList: Object {
    @objc dynamic var swapId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var isAlarm: Bool = false
    @objc dynamic var isDateCheck: Bool = false
    @objc dynamic var alramDate: Date? = nil

    override static func primaryKey() -> String? {
        return "swapId"
    }
    
    static func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(SwapList.self).max(ofProperty: "swapId") as Int? ?? 0) + 1
    }
    
    static func add(title: String, startDate: Date, endDate: Date, isAlarm: Bool, isDateCheck: Bool) {
        let newSwap = SwapList()
        newSwap.swapId = incrementID()
        newSwap.title = title
        newSwap.startDate = startDate
        newSwap.endDate = endDate
        newSwap.isAlarm = isAlarm
        newSwap.isDateCheck = isDateCheck

        let realm = try! Realm()
        try! realm.write {
            realm.add(newSwap)
        }
    }
    
    static func delete(swapId: Int) {
        let realm = try! Realm()
        if let swapToDelete = realm.objects(SwapList.self).filter("swapId == %@", swapId).first {
            try! realm.write {
                realm.delete(swapToDelete)
            }
        }
    }
    
    static func isSwapInRange(target: Date) {
        let realm = try! Realm()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: target)
        let swapLists = realm.objects(SwapList.self)

        try! realm.write {
            for swap in swapLists {
                let swapStartDateComponents = calendar.dateComponents([.year, .month, .day], from: swap.startDate)
                let swapEndDateComponents = calendar.dateComponents([.year, .month, .day], from: swap.endDate)
                if let date = calendar.date(from: dateComponents),
                   let swapStartDate = calendar.date(from: swapStartDateComponents),
                   let swapEndDate = calendar.date(from: swapEndDateComponents) {
                    if date >= swapStartDate && date <= swapEndDate {
                        swap.isDateCheck = true
                    } else {
                        swap.isDateCheck = false
                    }
                }
            }
        }
    }
    
    static func scheduleNotification(title: String, seletedTimeDate: Date, identifierCnt: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Swap 알림"
        content.body = "\(title)를 실천하실 시간이에요🙌"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Clock.mp3"))
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: seletedTimeDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //테스트용
        let request = UNNotificationRequest(identifier: "SwapAlarm_\(identifierCnt)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }

    static func scheduleNotificationsForRange(title: String, startDate: Date, endDate: Date, selectedTimeDate: Date) {
        let calendar = Calendar.current
        var alarmDate = startDate
        var identifierCnt = 1
        // startDate부터 endDate까지 반복하면서 알림 예약
        while alarmDate <= endDate {
            let notificationTime = calendar.date(bySettingHour: calendar.component(.hour, from: selectedTimeDate), minute: calendar.component(.minute, from: selectedTimeDate), second: 0, of: alarmDate)!
            scheduleNotification(title: title, seletedTimeDate: notificationTime, identifierCnt: identifierCnt)

            // 다음 날짜로 설정
            alarmDate = calendar.date(byAdding: .day, value: 1, to: alarmDate)!
            identifierCnt += 1
        }
    }
}
