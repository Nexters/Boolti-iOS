//
//  ConcertEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/9/24.
//

import Foundation

struct ConcertEntity: Equatable {
    let id: Int
    let name: String
    let dateTime: Date
    let salesStartTime: Date
    let salesEndTime: Date
    let posterPath: String
}
