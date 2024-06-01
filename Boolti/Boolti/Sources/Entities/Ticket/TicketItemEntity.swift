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
    let reservationID: Int
    let location: String
    let ticketCount: Int
}
