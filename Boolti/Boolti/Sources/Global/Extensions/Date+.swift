//
//  Date+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import Foundation

enum DateType: String {
    case simple = "mm월 dd일"
    case date = "yyyy.MM.dd (E)"
    case dateTime = "yyyy.MM.dd (E) HH:mm"
    case dateSlashTime = "yyyy.MM.dd (E) / HH:mm"
}

extension Date {

    func format(_ format: DateType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
        
        return formatter.string(from: self)
    }
}
