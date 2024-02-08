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
}
