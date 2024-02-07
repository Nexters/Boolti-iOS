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
    let hostName: String
    let hostPhoneNumber: String
    
    struct Poster {
        let id: Int
        let path: String
        let thumbnailPath: String
        let sequence: Int
    }
    
    init(id: Int = 0,
         groupId: Int = 0,
         name: String = "",
         placeName: String = "",
         date: Date = Date(),
         runningTime: Int = 0,
         streetAddress: String = "",
         detailAddress: String = "",
         notice: String = "",
         salesStartTime: Date = Date(),
         salesEndTime: Date = Date(),
         posters: [Poster] = [],
         hostName: String = "",
         hostPhoneNumber: String = "") {
        
        self.id = id
        self.groupId = groupId
        self.name = name
        self.placeName = placeName
        self.date = date
        self.runningTime = runningTime
        self.streetAddress = streetAddress
        self.detailAddress = detailAddress
        self.notice = notice
        self.salesStartTime = salesStartTime
        self.salesEndTime = salesEndTime
        self.posters = posters
        self.hostName = hostName
        self.hostPhoneNumber = hostPhoneNumber
    }
}
