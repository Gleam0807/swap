//
//  SwapList.swift
//  swap
//
//  Created by SUNG on 2/12/24.
//

import UIKit
import RealmSwift

class SwapRecord: Object {
    @Persisted(primaryKey: true) var recordId: Int
    @Persisted var recordDate: Date
    @Persisted var swapId: Int
    @Persisted var title: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var memo: String
    @Persisted var firstImage: Data?
    @Persisted var secondImage: Data?
    @Persisted var thirdImage: Data?
    @Persisted var fourthImage: Data?
    
    convenience init(recordDate: Date, swapId: Int, title: String, startDate: Date, endDate: Date, memo: String, firstImage: Data? = nil, secondImage: Data? = nil, thirdImage: Data? = nil, fourthImage: Data? = nil) {
        self.init()
        self.recordDate = recordDate
        self.swapId = swapId
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.memo = memo
        self.firstImage = firstImage
        self.secondImage = secondImage
        self.thirdImage = thirdImage
        self.fourthImage = fourthImage
    }

}
