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
    let reservationStatus: Bool
    
    struct Poster {
        let id: Int
        let path: String
        let thumbnailPath: String
        let sequence: Int
    }
    
    func convertToShareConcertString() -> String {
        let formattedString = """
        공연 정보를 공유드려요!

        공연명 : \(name)
        일시 : \(date.format(.dateDayTimeWithDash))
        장소 : \(placeName) / \(streetAddress), \(detailAddress)

        공연 상세 정보 ▼ 
        https://preview.boolti.in/show/\(id)
        """
        
        return formattedString
    }
}
