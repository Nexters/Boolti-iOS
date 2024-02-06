//
//  TicketListResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/6/24.
//

import Foundation

struct TicketListResponseDTO: Decodable {

    let userID: Int
    let ticketID: Int
    let concertTitle: String
    let placeName: String
    let concertDate: String
    let concertImagePath: String
    let ticketType: String
    let ticketName: String
    let entryCode: String
    let isUsedTicket: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case ticketID = "ticketId"
        case concertTitle = "showName"
        case concertDate = "showDate"
        case concertImagePath = "showImgPath"
        case isUsedTicket = "isUsed"
        case placeName, entryCode, ticketName, ticketType
    }
}
