//
//  OrderGiftPaymentRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/22/24.
//

struct OrderGiftPaymentRequestDTO: Codable {
    
    let orderId: String
    let amount: Int
    let paymentKey: String
    let showId: Int
    let salesTicketTypeId: Int
    let ticketCount: Int
    let giftImgId: Int
    let message: String
    let senderName: String
    let senderPhoneNumber: String
    let recipientName: String
    let recipientPhoneNumber: String
    let depositorName: String
    let depositorPhoneNumber: String
    
}
