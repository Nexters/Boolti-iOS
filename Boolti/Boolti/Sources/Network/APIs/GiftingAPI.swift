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
    case freeGifting(requestDTO: FreeGiftingRequestDTO)
    case giftCardImages
    case registerGift(requestDTO: RegisterGiftRequestDTO)
}

extension GiftingAPI: ServiceAPI {

    var path: String {
        switch self {
        case .orderGiftPayment:
            return "/api/v1/order/gift-approve-payment"
        case .freeGifting:
            return "/api/v1/order/free-gift-reservation"
        case .giftCardImages:
            return "/api/v1/gift/img-list"
        case .registerGift:
            return "api/v1/order/receive-gift"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .orderGiftPayment, .freeGifting, .registerGift:
            return .post
        case .giftCardImages:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .orderGiftPayment(let DTO):
            return .requestJSONEncodable(DTO)
        case .freeGifting(let DTO):
            return .requestJSONEncodable(DTO)
        case .giftCardImages:
            return .requestPlain
        case .registerGift(let DTO):
            return .requestJSONEncodable(DTO)
        }
    }
}
