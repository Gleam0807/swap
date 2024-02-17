//
//  SwapList.swift
//  swap
//
//  Created by SUNG on 2/12/24.
//

import UIKit
import PhotosUI

struct SwapRecord {
    static var swapRecords = [SwapRecord]()
    
    var swapId: Int
    var title: String
    var startDate: Date
    var endDate: Date
    var recordDate: Date
    var memo: String
    var images: [String]
    
    static func add(swapId: Int, title: String, startDate: Date, endDate: Date, recordDate: Date, memo: String, images: [String]) {
        let newSwap = SwapRecord(swapId: swapId, title: title, startDate: startDate, endDate: endDate, recordDate: recordDate, memo: memo, images: images)
        swapRecords.append(newSwap)
    }
    
    init(swapId: Int, title: String, startDate: Date, endDate: Date, recordDate: Date, memo: String, images: [String]) {
        self.swapId = swapId
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.recordDate = recordDate
        self.memo = memo
        self.images = images
    }
        

}
