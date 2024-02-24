//
//  SwapListRepository.swift
//  swap
//
//  Created by SUNG on 2/24/24.
//

import Foundation
import AVFoundation
import UserNotifications
import RealmSwift

protocol SwapListRepositoryType {
    func incrementID() -> Int
    func fetch() -> [SwapList]
    func add(_ swapLists: SwapList)
    func delete(swapId: Int)
    func dateRangeFilter() -> [SwapList]
    func isSwapInRange(target: Date)
    func scheduleNotificationsForRange(title: String, startDate: Date, endDate: Date, selectedTimeDate: Date)
    func scheduleNotification(title: String, seletedTimeDate: Date, identifierCnt: Int)
}

let config = Realm.Configuration(
    schemaVersion: 3,  // 새로운 스키마 버전 설정
    // 마이그레이션 블록 정의
    migrationBlock: { migration, oldSchemaVersion in
        if oldSchemaVersion < 3 {
            // 이전 버전과 호환되지 않는 변경사항을 처리하는 로직 추가
            // 예: 이전 버전의 스키마를 새로운 버전으로 변환하는 작업 수행
            // migration.enumerateObjects(ofType: SwapList.className()) { oldObject, newObject in
            //     newObject!["newProperty"] = someValue
            // }
        }
    }
)

class SwapListRepository: SwapListRepositoryType {
    let realm = try! Realm(configuration: config)
    
    func incrementID() -> Int {
        return (realm.objects(SwapList.self).max(ofProperty: "swapId") as Int? ?? 0) + 1
    }
    
    func fetch() -> [SwapList] {
        return Array(realm.objects(SwapList.self))
    }
    
    func add(_ swapLists: SwapList) {
        swapLists.swapId = incrementID()
        try! realm.write {
            realm.add(swapLists)
        }
    }
    
    func delete(swapId: Int) {
        if let swapToDelete = realm.objects(SwapList.self).filter("swapId == %@", swapId).first {
            try! realm.write {
                realm.delete(swapToDelete)
            }
        }
    }
    
    func dateRangeFilter() -> [SwapList] {
        let results = realm.objects(SwapList.self).filter("isDateCheck == true")
        return Array(results)
    }
    
    func isSwapInRange(target: Date) {
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
    
    func scheduleNotification(title: String, seletedTimeDate: Date, identifierCnt: Int) {
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

    func scheduleNotificationsForRange(title: String, startDate: Date, endDate: Date, selectedTimeDate: Date) {
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
