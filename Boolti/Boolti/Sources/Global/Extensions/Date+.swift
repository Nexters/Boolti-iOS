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
}
