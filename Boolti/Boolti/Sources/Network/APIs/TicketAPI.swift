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
    case detail(requestDTO: TicketDetailRequestDTO)
    case entryCode(requestDTO: TicketEntryCodeRequestDTO)
}

extension TicketAPI: ServiceAPI {

    var path: String {
        switch self {
        case .list:
            return "/api/v1/tickets"
        case .detail(let DTO):
            return "/api/v1/ticket/\(DTO.ticketID)"
        case .entryCode:
            return "/api/v1/ticket/entrance/manager"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list, .detail:
            return .get
        case .entryCode:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .list, .detail:
            return .requestPlain
        case .entryCode(let DTO):
            let params: [String: Any]
            params = ["ticketId": DTO.ticketID, "showId": DTO.concertID, "managerCode": DTO.entryCode]
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
        }
    }
}
