//
//  DateFormatter.swift
//  swap
//
//  Created by SUNG on 3/5/24.
//

import Foundation

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
    
    var alarmConvertedDateFormatter: DateFormatter {
        let formatter = self
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    
    var calendarDisplayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
     }
}
