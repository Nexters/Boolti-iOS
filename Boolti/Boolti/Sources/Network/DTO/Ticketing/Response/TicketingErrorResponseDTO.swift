//
//  ErrorResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 5/1/24.
//

struct TicketingErrorResponseDTO: Decodable {
    let tossMessage: String
    let orderId: String
    let errorTraceId: String
    let type: String
    let detail: String
}
