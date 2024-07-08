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
    let streetAddress: String
    let notice: String
    let ticketNotice: String
    let concertID: Int
    let hostName: String
    let hostPhoneNumber: String
    let ticketInformations: [TicketDetailInformation]
}

struct TicketDetailInformation {
    let ticketName: String
    let entryCode: String
    let ticketStatus: TicketStatus
    let ticketID: Int
    let csTicketID: String
}
