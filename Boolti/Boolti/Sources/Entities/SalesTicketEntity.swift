//
//  SalesTicketEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import Foundation

struct SalesTicketEntity {
    // 일단 여러 티켓 살 수 없음을 가정해서 매수는 1개로 고정
    let id: Int
    let showId: Int
    let ticketType: TicketType
    let ticketName: String
    let price: Int
    let quantity: Int
    
    enum TicketType: String {
        case sales = "SALE"
        case invite = "INVITE"
    }
}
