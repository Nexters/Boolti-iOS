//
//  TicketEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import Foundation

struct TicketEntity: Hashable {
    let id: Int
    let name: String
    let price: Int
    let inventory: Int
}
