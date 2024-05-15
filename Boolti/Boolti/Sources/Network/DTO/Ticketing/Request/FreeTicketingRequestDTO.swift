//
//  FreeTicketingRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/12/24.
//

struct FreeTicketingRequestDTO: Encodable {
    
    let userId: Int
    let showId: Int
    let salesTicketTypeId: Int
    let ticketCount: Int
    let reservationName: String
    let reservationPhoneNumber: String
    
}
