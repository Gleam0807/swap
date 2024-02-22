//
//  SwapListObject.swift
//  swap
//
//  Created by SUNG on 2/22/24.
//

import UIKit
import AVFoundation
import UserNotifications
import RealmSwift

class SwapListObject: Object {
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
        return (realm.objects(SwapListObject.self).max(ofProperty: "swapId") as Int? ?? 0) + 1
    }
    
    static func add(title: String, startDate: Date, endDate: Date, isAlarm: Bool, isDateCheck: Bool) {
        let newSwap = SwapListObject()
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
}
