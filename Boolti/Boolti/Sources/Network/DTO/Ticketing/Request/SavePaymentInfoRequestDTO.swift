//
//  SavePaymentInfoRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/19/24.
//

import Foundation

struct SavePaymentInfoRequestDTO: Encodable {
    
    let showId: Int
    let salesTicketTypeId: Int
    let ticketCount: Int
    
}
