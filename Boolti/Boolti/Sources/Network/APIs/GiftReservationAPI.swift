//
//  GiftReservationAPI.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import Foundation

import Moya

enum GiftReservationAPI {

    case detail(requestDTO: GiftReservationDetailRequestDTO)
}

extension GiftReservationAPI: ServiceAPI {

    var path: String {
        switch self {
        case .detail(let DTO):
            return "/api/v1/gift/approve-payment-info/\(DTO.giftID)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .detail:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .detail:
            return .requestPlain
        }
    }
}

