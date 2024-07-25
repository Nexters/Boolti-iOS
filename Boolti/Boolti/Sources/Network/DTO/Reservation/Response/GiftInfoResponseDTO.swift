//
//  GiftInfoResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/24/24.
//

import Foundation

struct GiftInfoResponseDTO: Decodable {
    
    let id: Int
    let userId: Int
    let orderId: String?
    let giftUuid: String
    let reservationId: Int
    let giftImgId: Int
    let giftImgPath: String
    let message: String
    let senderName: String
    let senderPhoneNumber: String
    let recipientName: String
    let recipientPhoneNumber: String
    let status: String
    let isDone: Bool
    let cancelledAt: String?
    let salesEndTime: String
    let createdAt: String
    let modifiedAt: String?
    let removedAt: String?
    
}

extension GiftInfoResponseDTO {
    
    func getGiftSenderId() -> Int {
        return self.userId
    }
    
}
