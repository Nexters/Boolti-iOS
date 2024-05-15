//
//  TicketRefundRequestDTO.swift
//  Boolti
//
//  Created by Miro on 2/14/24.
//

import Foundation

struct TicketRefundRequestDTO: Encodable {
    let reservationId: Int
    let cancelReason: String
}
