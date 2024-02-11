//
//  Date+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import Foundation

enum DateFormatType: String {
    case simple = "M월 d일"
    case dateDay = "yyyy.MM.dd (E)"
    case dateDayTime = "yyyy.MM.dd (E) HH:mm"
    case dateTime = "yyyy.MM.dd HH:mm"
    case dateDayTimeWithSlash = "yyyy.MM.dd (E) / HH:mm"
    case isoDateTime = "yyyy-MM-dd'T'HH:mm:ss"
}

extension DateFormatType {

    var formatter: DateFormatter {
        let formatter = ISO8601DateFormatter()

        guard let formatter = DateFormatType.cachedFormatters[self] else {
            let generatedFormatter = DateFormatType.makeFormatter(withDateFormat: self)
            DateFormatType.cachedFormatters[self] = generatedFormatter
            return generatedFormatter
        }

        return formatter
    }

    private static var cachedFormatters: [DateFormatType: DateFormatter] = [:]

    private static func makeFormatter(withDateFormat dateFormatType: DateFormatType) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatType.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
}

extension Date {

    func format(_ formatType: DateFormatType) -> String {
        return formatType.formatter.string(from: self)
    }
    
    func getBetweenDay(to endDate: Date) -> Int {
        let calendar = Calendar.current
        let startMidnight = calendar.startOfDay(for: self)
        let endMidnight = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: startMidnight, to: endMidnight)
        return components.day ?? 0
    }
}
