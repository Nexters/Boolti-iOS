//
//  ConcertAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import Foundation

import Moya

enum ConcertAPI {

    case list(requesDTO: ConcertListRequestDTO)
    case detail(requestDTO: ConcertDetailRequestDTO)
    case salesTicket(requestDTO: SalesTicketRequestDTO)
    case salesTicketing(requestDTO: SalesTicketingRequestDTO)
    case checkInvitationCode(requestDTO: CheckInvitationCodeRequestDTO)
}

extension ConcertAPI: ServiceAPI {

    var path: String {
        switch self {
        case .list:
            return "/papi/v1/shows/search"
        case .detail(let DTO):
            return "/papi/v1/show/\(DTO.id)"
        case .salesTicket(let DTO):
            return "/api/v1/sales-ticket-type/\(DTO.showId)"
        case .salesTicketing:
            return "/api/v1/reservation/sales-ticket"
        case .checkInvitationCode:
            return "api/v1/check/invite-code"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .salesTicketing:
            return .post
        default:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .list(let DTO):
            let query: [String: Any] = [
                "nameLike": DTO.nameLike ?? ""
            ]
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
        case .salesTicketing(let DTO):
            return .requestJSONEncodable(DTO)
        case .checkInvitationCode(let DTO):
            let query: [String: Any] = [
                "showId": DTO.showId,
                "salesTicketTypeId": DTO.salesTicketTypeId,
                "inviteCode": DTO.inviteCode
            ]
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
}
