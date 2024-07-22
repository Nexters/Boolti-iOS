//
//  GiftingAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/22/24.
//

import Foundation

import Moya

enum GiftingAPI {
    case orderGiftPayment(requestDTO: OrderGiftPaymentRequestDTO)
}

extension GiftingAPI: ServiceAPI {

    var path: String {
        switch self {
        case .orderGiftPayment:
            return "/api/v1/order/gift-approve-payment"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .orderGiftPayment:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .orderGiftPayment(let DTO):
            return .requestJSONEncodable(DTO)
        }
    }
}
