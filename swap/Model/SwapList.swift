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
    
    static func isSwapInRange(target: Date) -> [SwapList] {
        print("target\(target)")
        let calendar = Calendar.current
        let realm = try! Realm()
        let targetDateComponents = calendar.dateComponents([.year, .month, .day], from: target)
        let datas = realm.objects(SwapList.self).filter { swapList in
            // swapList의 startDate와 endDate를 년월일로 변환합니다.
            let startComponents = calendar.dateComponents([.year, .month, .day], from: swapList.startDate)
            let endComponents = calendar.dateComponents([.year, .month, .day], from: swapList.endDate)

            // target이 startDate와 endDate 사이에 있는지 확인합니다.
            let isWithinRange = calendar.compare(target, to: swapList.startDate, toGranularity: .day) != .orderedAscending &&
                                calendar.compare(target, to: swapList.endDate, toGranularity: .day) != .orderedDescending
            print(isWithinRange)
            return isWithinRange
        }
        return Array(datas)
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
