//
//  SwapCompletedList.swift
//  swap
//
//  Created by SUNG on 2/20/24.
//

import UIKit
import RealmSwift

class SwapCompletedList: Object {
    @Persisted(primaryKey: true) var swapCompletedId: Int
    @Persisted var swapId: Int
    @Persisted var completedDate: Date
    @Persisted var isCompleted: Bool
    
    convenience init(swapId: Int, completedDate: Date, isCompleted: Bool) {
        self.init()
        self.swapId = swapId
        self.completedDate = completedDate
        self.isCompleted = isCompleted
    }
}
