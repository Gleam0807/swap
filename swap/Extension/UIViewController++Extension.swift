//
//  UIViewController++Extension.swift
//  swap
//
//  Created by SUNG on 2/18/24.
//

import UIKit

extension UIViewController {
    func isDateInRange(startDate: Date, endDate: Date, target: Date) -> Bool {
        let isStarted = startDate <= target
        let isEnd = endDate < target
        return startDate == endDate ? true : isStarted && !isEnd
    }
}

extension DateFormatter {
    var displayDateFormatter: DateFormatter {
        let formatter = self
        formatter.dateFormat = "yyyy년 MM월"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    var recordDisplayDateFormatter: DateFormatter {
        let formatter = self
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    var recordProgressDateFormatter: DateFormatter {
        let formatter = self
        formatter.dateFormat = "yy/MM/dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    var currentConvertedDate: DateFormatter {
        let formatter = self
        formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    var alarmConvertedDate: DateFormatter {
        let formatter = self
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
}
