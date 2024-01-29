//
//  TicketSection.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import Foundation
import RxCocoa
import RxDataSources

enum TicketSectionItem {
    case conformingDepositTicket(id: Int, title: String)
    case usableTicket(item: UsableTicket)
    case usedTicket(item: UsedTicket)
}

enum TicketSection {
    case conformingDeposit(items: [TicketSectionItem])
    case usable(items: [TicketSectionItem])
    case used(items: [TicketSectionItem])
}

extension TicketSection: SectionModelType {

    init(original: TicketSection, items: [TicketSectionItem]) {
        switch original {
        case .conformingDeposit(items: let items):
            self = .conformingDeposit(items: items)
        case .usable(items: let items):
            self = .usable(items: items)
        case .used(items: let items):
            self = .used(items: items)
        }
    }
    
    var items: [TicketSectionItem] {
        switch self {
        case .conformingDeposit(items: let items):
            return items.map { $0 }
        case .usable(items: let items):
            return items.map { $0 }
        case .used(items: let items):
            return items.map { $0 }
        }
    }
}


