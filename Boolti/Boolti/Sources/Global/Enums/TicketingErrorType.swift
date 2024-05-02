//
//  TicketingErrorType.swift
//  Boolti
//
//  Created by Juhyeon Byun on 5/2/24.
//

enum TicketingErrorType {
    case noQuantity
    case tossError

    init?(rawValue: String) {
        switch rawValue {
        case "NO_REMAINING_QUANTITY":
            self = .noQuantity
        default:
            self = .tossError
        }
    }
}
