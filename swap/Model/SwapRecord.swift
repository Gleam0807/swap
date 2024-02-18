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
    var images: [UIImage]
    
    static func add(swapId: Int, title: String, startDate: Date, endDate: Date, recordDate: Date, memo: String, images: [UIImage]) {
        let newSwap = SwapRecord(swapId: swapId, title: title, startDate: startDate, endDate: endDate, recordDate: recordDate, memo: memo, images: images)
        swapRecords.append(newSwap)
    }
    
    static func isDuplicate(swapId: Int, recordDate: Date) -> Bool {
        return swapRecords.contains { $0.swapId == swapId && $0.recordDate == recordDate }
    }
    
    static func update(swapId: Int, memo: String, images: [UIImage]) {
        guard let swapIndex = swapRecords.firstIndex(where: { $0.swapId == swapId }) else { return }
        
        swapRecords[swapIndex].memo = memo
        swapRecords[swapIndex].images = images
    }
    
    init(swapId: Int, title: String, startDate: Date, endDate: Date, recordDate: Date, memo: String, images: [UIImage]) {
        self.swapId = swapId
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.recordDate = recordDate
        self.memo = memo
        self.images = images
    }
        

}
