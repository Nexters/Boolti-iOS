//
//  TicketItem.swift
//  Boolti
//
//  Created by Miro on 2/2/24.
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

struct TicketItem: Hashable {

    let id = UUID()
    let ticketType: TicketType
    let poster: UIImage
    let title: String
    let date: String
    let location: String
    let qrCode: UIImage
    let number: Int
}
