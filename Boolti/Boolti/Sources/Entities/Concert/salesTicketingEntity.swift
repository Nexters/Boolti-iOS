//
//  TicketingEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/30/24.
//

import Foundation

struct TicketingEntity {
    var concert: ConcertDetailEntity
    var ticketHolder: userInfo
    var depositor: userInfo?
    var selectedTicket: [SelectedTicketEntity]
    var reservationId: Int

    var invitationCode: String?
    
    struct userInfo {
        var name: String
        var phoneNumber: String
    }
}
