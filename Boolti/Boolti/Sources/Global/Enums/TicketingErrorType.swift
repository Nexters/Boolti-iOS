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
        case "No remaining quantity":
            self = .noQuantity
        default:
            self = .tossError
        }
    }
}
