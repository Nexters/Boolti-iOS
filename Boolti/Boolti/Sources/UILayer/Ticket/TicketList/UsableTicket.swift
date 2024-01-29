//
//  IssuedTicket.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit

// 아마도 각 공연마다 서로 다를 거여서 추후에 API 결정되면
// 각 공연별로 TicketType을 설정해야될듯!
enum TicketType {
    case invitation
    case premium

    var description: String {
        switch self {
        case .invitation:
            return "초청 티켓"
        case .premium:
            return "프리미엄 티켓"
        }
    }
}

struct UsableTicket {
    let ticketType: TicketType
    let poster: UIImage
    let title: String
    let date: String
    let location: String
    let qrCode: UIImage
    let number: Int
}
