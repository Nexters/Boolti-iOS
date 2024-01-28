//
//  IssuedTicket.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit

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

struct IssuedTicket {
    let ticketType: TicketType
    let poster: UIImage
    let title: String
    let date: String
    let location: String
    let QRCode: UIImage
}
