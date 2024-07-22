//
//  OrderGiftPaymentResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/22/24.
//

struct OrderGiftPaymentResponseDTO: Decodable {
    
    let orderId: String
    let reservationId: Int
    let giftId: Int
    let giftUuid: String
    
}
