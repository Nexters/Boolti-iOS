//
//  GiftingEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/21/24.
//

import Foundation

struct GiftingEntity {
    var concert: ConcertDetailEntity
    var sender: UserInfo
    var receiver: UserInfo
    var selectedTicket: SelectedTicketEntity
    var orderId: String?
    var giftId: Int?

    var message: String
    var giftImgId: Int
    
    struct UserInfo {
        var name: String
        var phoneNumber: String
    }
}
