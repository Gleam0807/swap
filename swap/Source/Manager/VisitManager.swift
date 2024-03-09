//
//  VisitManager.swift
//  swap
//
//  Created by SUNG on 3/5/24.
//

import Foundation

class VisitManager {
    static let shared = VisitManager()
    private let userDefaults = UserDefaults.standard
    private let visitCountKey = "visitCount"
    private let lastVisitDateKey = "lastVisitDate"
    
    private init() {}
    
    func increaseVisitCountIfNeeded() {
        let lastVisitDate = userDefaults.object(forKey: lastVisitDateKey) as? Date
        let currentDate = Date()
        
        // 이전 방문 날짜가 없거나 오늘과 다른 날짜라면 방문 횟수 증가
        if lastVisitDate == nil || !Calendar.current.isDate(currentDate, inSameDayAs: lastVisitDate!) {
            var visitCount = userDefaults.integer(forKey: visitCountKey)
  
            if visitCount == 0 {
                visitCount = 1
            } else {
                visitCount += 1
            }
            userDefaults.set(visitCount, forKey: visitCountKey)
            // 방문 날짜 갱신
            userDefaults.set(currentDate, forKey: lastVisitDateKey)
        }
    }
    
    func getVisitCount() -> Int {
        return userDefaults.integer(forKey: visitCountKey)
    }
    
    func resetVisitCount() {
        userDefaults.removeObject(forKey: visitCountKey)
        userDefaults.removeObject(forKey: lastVisitDateKey)
    }
}
