//
//  TicketReservationAPI.swift
//  Boolti
//
//  Created by Miro on 2/10/24.
//

import Foundation

import Moya

enum TicketReservationAPI {

    case reservations
    case detail(requestDTO: TicketReservationDetailRequestDTO)
    case requestRefund(requestDTO: TicketRefundRequestDTO)
}

extension TicketReservationAPI: ServiceAPI {

    var path: String {
        switch self {
        case .reservations:
            return "/api/v1/reservations"
        case .detail(let DTO):
            return "/api/v1/reservation/\(DTO.reservationID)"
        case .requestRefund:
            return "/api/v1/reservation/refund"
        }
    }

    var method: Moya.Method {
        switch self {
        case .requestRefund:
            return .patch
        default:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .requestRefund(let DTO):
            let query: [String: Any] = [
                "reservationId": DTO.reservationID,
                "refundReason": DTO.refundReason,
                "refundPhoneNumber": DTO.refundPhoneNumber,
                "refundAccountName": DTO.refundAccountName,
                "refundAccountNumber": DTO.refundAccountNumber,
                "refundBankCode": DTO.refundBankCode,
            ]
            return .requestParameters(parameters: query, encoding: JSONEncoding.prettyPrinted)
        default:
            return .requestPlain
        }
    }
}
