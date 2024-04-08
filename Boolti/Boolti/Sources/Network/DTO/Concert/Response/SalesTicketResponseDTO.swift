//
//  SalesTicketResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/9/24.
//

import Foundation

struct SalesTicketResponseDTOElement: Decodable {
    let id: Int
    let showId: Int
    let ticketType: String
    let ticketName: String
    let price: Int
    let quantity: Int
}

typealias SalesTicketResponseDTO = [SalesTicketResponseDTOElement]

extension SalesTicketResponseDTO {
    
    func convertToSalesTicketEntities() -> [SelectedTicketEntity] {
        return self.map { ticket in
            let ticketType: TicketType = ticket.ticketType == "SALE" ? .sale : .invitation
            
            return SelectedTicketEntity(id: ticket.id,
                                        concertId: ticket.showId,
                                        ticketType: ticketType,
                                        ticketName: ticket.ticketName,
                                        price: ticket.price,
                                        quantity: ticket.quantity,
                                        count: 1)
        }
    }
}
