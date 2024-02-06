//
//  TicketListResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/6/24.
//

import Foundation

struct TicketListResponseDTO: Decodable {

    let ticketListItemResponseDTO: [TicketListItemResponseDTO]
}

extension TicketListResponseDTO {

    func converToTicketItems() -> [TicketItem] {
        return self.ticketListItemResponseDTO.map { $0.convertToTicketItem() }
    }
}
