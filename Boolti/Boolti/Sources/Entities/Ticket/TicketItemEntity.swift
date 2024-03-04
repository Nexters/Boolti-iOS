//
//  TicketItemEntity.swift
//  Boolti
//
//  Created by Miro on 2/2/24.
//

import UIKit

struct TicketItemEntity: Hashable {

    let ticketType: TicketType
    let ticketName: String
    let posterURLPath: String
    let title: String
    let date: String
    let location: String
    let qrCode: UIImage
    let ticketID: Int
    let csTicketID: String
    var ticketStatus: TicketStatus

    // 일단 ticketID를 통해서 유일한 객체를 만든다!..
    // 만약 item 중 ticketID가 동일한 것이 존재하면 안된다!
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.ticketID)
    }

    // 만약 ticketID가 동일하고, ticketStatus가 동일하면 같은 놈으로 취급한다.
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue && lhs.ticketStatus == rhs.ticketStatus
    }
}
