//
//  LandingDestination.swift
//  Boolti
//
//  Created by Miro on 4/5/24.
//

import Foundation

 enum LandingDestination: Codable {
     case reservationList
     case reservationDetail(reservationID: Int)
     case giftDetail(giftID: String)
     case concertDetail(concertId: Int)
     case concertList(giftUuid: String)
     // 추가될 예정
 }
