//
//  TicketingAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/19/24.
//

import Foundation

import Moya

enum TicketingAPI {
    case salesTicket(requestDTO: SalesTicketRequestDTO)
    case freeTicketing(requestDTO: FreeTicketingRequestDTO)
    case checkInvitationCode(requestDTO: CheckInvitationCodeRequestDTO)
    case invitationTicketing(requestDTO: InvitationTicketingRequestDTO)
    case savePaymentInfo(requestDTO: SavePaymentInfoRequestDTO)
    case orderPayment(requestDTO: OrderPaymentRequestDTO)
}

extension TicketingAPI: ServiceAPI {

    var path: String {
        switch self {
        case .salesTicket(let DTO):
            return "/api/v1/sales-ticket-type/\(DTO.showId)"
        case .freeTicketing:
            return "/api/v1/reservation/sales-ticket"
        case .checkInvitationCode:
            return "api/v1/check/invite-code"
        case .invitationTicketing:
            return "/api/v1/reservation/invite-ticket"
        case .savePaymentInfo:
            return "/api/v1/order/payment-info"
        case .orderPayment:
            return "/api/v1/order/approve-payment"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .freeTicketing, .invitationTicketing, .savePaymentInfo, .orderPayment:
            return .post
        default:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .freeTicketing(let DTO):
            return .requestJSONEncodable(DTO)
        case .checkInvitationCode(let DTO):
            let query: [String: Any] = [
                "showId": DTO.showId,
                "salesTicketTypeId": DTO.salesTicketTypeId,
                "inviteCode": DTO.inviteCode
            ]
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
        case .invitationTicketing(let DTO):
            return .requestJSONEncodable(DTO)
        case .savePaymentInfo(let DTO):
            return .requestJSONEncodable(DTO)
        case .orderPayment(let DTO):
            return .requestJSONEncodable(DTO)
        default:
            return .requestPlain
        }
    }
}
