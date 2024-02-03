//
//  TicketingEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/30/24.
//

import Foundation

struct TicketingEntity {
    let ticketHolder: userInfo
    let depositor: userInfo?
    let selectedTicket: [SalesTicketEntity]

    // 현재는 계좌이체만 가능
    let paymentMethod: String
    let invitationCode: String?
    
    struct userInfo {
        let name: String
        let phoneNumber: String
    }
}
