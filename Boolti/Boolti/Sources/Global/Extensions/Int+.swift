//
//  Int+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import Foundation

extension Int {
    func formattedCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
