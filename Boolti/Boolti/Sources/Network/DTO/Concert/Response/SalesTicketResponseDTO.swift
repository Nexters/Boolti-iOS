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
    
    func convertToSalesTicketEntities() -> [SalesTicketEntity] {
        return self.map { ticket in
            var ticketType: SalesTicketEntity.TicketType = .invite

            switch ticket.ticketType {
            case SalesTicketEntity.TicketType.invite.rawValue:
                ticketType = .invite
            case SalesTicketEntity.TicketType.sales.rawValue:
                ticketType = .sales
            default:
                break
            }
            
            return SalesTicketEntity(id: ticket.id,
                                     concertId: ticket.showId,
                                     ticketType: ticketType,
                                     ticketName: ticket.ticketName,
                                     price: ticket.price,
                                     quantity: ticket.quantity)
        }
    }
}
