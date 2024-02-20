//
//  TicketDetailItem.swift
//  Boolti
//
//  Created by Miro on 2/6/24.
//

import UIKit

struct TicketDetailItemEntity {

    let ticketType: TicketType
    let ticketName: String
    let posterURLPath: String
    let title: String
    let date: String
    let location: String
    let qrCode: UIImage
    let notice: String
    let ticketID: Int
    let concertID: Int
    let hostName: String
    let hostPhoneNumber: String
    let ticketStatus: TicketStatus
    let usedAt: String?
}
