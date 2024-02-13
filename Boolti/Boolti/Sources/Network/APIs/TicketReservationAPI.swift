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
}

extension TicketReservationAPI: ServiceAPI {

    var path: String {
        switch self {
        case .reservations:
            return "/api/v1/reservations"
        case .detail(let DTO):
            return "/api/v1/reservation/\(DTO.reservationID)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        return .requestPlain
    }
}
