//
//  SelectedTicketEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import Foundation

struct SelectedTicketEntity {
    let id: Int
    let concertId: Int
    let ticketType: TicketType
    let ticketName: String
    let price: Int
    let quantity: Int
    var count: Int = 1
}
