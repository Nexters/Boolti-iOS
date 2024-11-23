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
    case cancelGift(giftUUID: String)
}

extension TicketAPI: ServiceAPI {

    var path: String {
        switch self {
        case .list:
            return "/api/v1/reservation/tickets"
        case .detail(let DTO):
            return "/api/v1/ticket/reservation/\(DTO.reservationID)"
        case .entryCode:
            return "/api/v1/ticket/entrance/manager"
        case .cancelGift:
            return "/api/v1/order/cancel-receive-gift"
        }
    }

    var method: Moya.Method {
        switch self {
        case .list, .detail:
            return .get
        case .entryCode, .cancelGift:
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
        case .cancelGift(let giftUUID):
            let params: [String: Any]
            params = ["giftUuid": giftUUID]
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
        }
    }
}
