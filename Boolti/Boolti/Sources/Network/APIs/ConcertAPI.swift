//
//  ConcertAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import Foundation

import Moya

enum ConcertAPI {

    case detail(requestDTO: ConcertDetailRequestDTO)
    case salesTicket(requestDTO: SalesTicketRequestDTO)
}

extension ConcertAPI: ServiceAPI {

    var path: String {
        switch self {
        case .detail(let DTO):
            return "/papi/v1/show/\(DTO.id)"
        case .salesTicket(let DTO):
            return "/api/v1/sales-ticket-type/\(DTO.showId)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        return .requestPlain
    }
}
