//
//  TicketRefundRequestDTO.swift
//  Boolti
//
//  Created by Miro on 2/14/24.
//

import Foundation

struct TicketRefundRequestDTO {
    let reservationID: Int
    let refundReason: String
    let refundPhoneNumber: String
    let refundAccountName: String
    let refundAccountNumber: String
    let refundBankCode: String
}
