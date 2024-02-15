//
//  TicketItemEntity.swift
//  Boolti
//
//  Created by Miro on 2/2/24.
//

import UIKit

struct TicketItemEntity: Hashable {

    let id = UUID()
    let ticketType: TicketType
    let ticketName: String
    let posterURLPath: String
    let title: String
    let date: String
    let location: String
    let qrCode: UIImage
    let ticketID: Int
    let ticketStatus: TicketStatus
}
