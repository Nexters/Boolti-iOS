//
//  TicketAPI.swift
//  Boolti
//
//  Created by Miro on 2/6/24.
//

import Foundation
import Moya

enum TicketAPI {

    case list
    case detail(ticketID: String)
}

extension TicketAPI: ServiceAPI {

    var path: String {
        switch self {
        case .list:
            return "/api/v1/tickets"
        case .detail(ticketID: let id):
            return "/api/v1/ticket/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        return .requestPlain
    }
}