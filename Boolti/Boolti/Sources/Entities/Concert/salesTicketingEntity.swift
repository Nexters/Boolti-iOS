//
//  TicketingEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/30/24.
//

import Foundation

struct TicketingEntity {
    var concert: ConcertDetailEntity
    var ticketHolder: UserInfo
    var depositor: UserInfo?
    var selectedTicket: SelectedTicketEntity
    var orderId: String?
    var reservationId: Int

    var invitationCode: String?
    
    struct UserInfo {
        var name: String
        var phoneNumber: String
    }
}
