//
//  String+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/8/24.
//

import Foundation

extension String {
    
    func formatToDate() -> Date {
        return DateFormatType.isoDateTime.formatter.date(from: self) ?? Date()
    }
    
    func formatPhoneNumber() -> String {
        var formattedNumber = ""
        for (index, number) in Array(self.replacingOccurrences(of: "-", with: "")).enumerated() {
            if index == 3 || index == 7 {
                formattedNumber.append("-")
            }
            formattedNumber.append(number)
        }
        return formattedNumber
    }
}
