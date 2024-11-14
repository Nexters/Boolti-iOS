//
//  ConcertDetailEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/6/24.
//

import UIKit

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
    let salesTicketCount: Int
    let ticketingState: ConcertTicketingState

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

enum ConcertTicketingState {
    case onSale
    case beforeSale(startDate: Date)
    case endSale
    case endConcert

    var title: String {
        switch self {
        case .onSale: "예매하기"
        case .endSale: "예매 종료"
        case .endConcert: "공연 종료"
        default: ""
        }
    }

    var titleColor: UIColor {
        switch self {
        case .beforeSale: .orange01
        case .onSale: .white00
        default: .grey50
        }
    }

    var isEnabled: Bool {
        switch self {
        case .onSale: true
        default: false
        }
    }
}
