//
//  ConcertDetailEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/6/24.
//

import Foundation

struct ConcertDetailEntity {
    let id: Int
    let groupId: Int
    let name: String
    let placeName: String
    let date: Date
    let runningTime: Int
    let streetAddress: String
    let detailAddress: String
    let notice: String
    let salesStartTime: Date
    let salesEndTime: Date
    let posters: [Poster]
    
    struct Poster {
        let id: Int
        let path: String
        let thumbnailPath: String
        let sequence: Int
    }
}
