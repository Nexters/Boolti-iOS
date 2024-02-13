//
//  TicketEntryCodeRequestDTO.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

struct TicketEntryCodeRequestDTO: Encodable {
    let ticketID: String
    let concertID: String
    let entryCode: String
}
