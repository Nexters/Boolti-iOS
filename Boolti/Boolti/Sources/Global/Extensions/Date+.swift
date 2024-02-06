//
//  Date+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import Foundation

enum DateType: String {
    case simple = "M월 d일"
    case date = "yyyy.MM.dd (E)"
    case dateTime = "yyyy.MM.dd (E) HH:mm"
    case dateSlashTime = "yyyy.MM.dd (E) / HH:mm"
}

extension Date {

    func format(_ format: DateType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    func getBetweenDay(to endDate: Date) -> Int {
        let calendar = Calendar.current
        let startMidnight = calendar.startOfDay(for: self)
        let endMidnight = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: startMidnight, to: endMidnight)
        return components.day ?? 0
    }
}
