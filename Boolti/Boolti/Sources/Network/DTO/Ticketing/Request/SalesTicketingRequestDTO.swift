//
//  SalesTicketingRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/12/24.
//

import Foundation

struct SalesTicketingRequestDTO: Encodable {
    
    let userId: Int
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
