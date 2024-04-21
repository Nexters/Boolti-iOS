//
//  OrderPaymentRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/21/24.
//

struct OrderPaymentRequestDTO: Codable {
    
    let orderId: String
    let amount: Int
    let paymentKey: String
    let showId: Int
    let salesTicketTypeId: Int
    let ticketCount: Int
    let reservationName: String
    let reservationPhoneNumber: String
    let depositorName: String
    let depositorPhoneNumber: String
    let paymentAmount: Int
    let means: String
    
}
