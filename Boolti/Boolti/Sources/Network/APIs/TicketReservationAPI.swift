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
        case .requestRefund: // 요건 결제 API랑 같이 이어 붙히면 좋을듯!
            return "/api/v1/order/cancel-payment"
        }
    }

    var method: Moya.Method {
        switch self {
        case .requestRefund:
            return .post
        default:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .requestRefund(let DTO):
            return .requestJSONEncodable(DTO)
        default:
            return .requestPlain
        }
    }
}
