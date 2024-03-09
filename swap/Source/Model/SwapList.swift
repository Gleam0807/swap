//
//  SwapList.swift
//  swap
//
//  Created by SUNG on 2/23/24.
//

import UIKit
import RealmSwift

class SwapList: Object {
    @Persisted(primaryKey: true) var swapId: Int = 0
    @Persisted var title: String = ""
    @Persisted var isCompleted: Bool = false
    @Persisted var startDate: Date = Date()
    @Persisted var endDate: Date = Date()
    @Persisted var isAlarm: Bool = false
    @Persisted var isDateCheck: Bool = false
    
    convenience init(title: String, startDate: Date, endDate: Date, isAlarm: Bool, isDateCheck: Bool) {
        self.init()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.isAlarm = isAlarm
        self.isDateCheck = isDateCheck
    }
}
