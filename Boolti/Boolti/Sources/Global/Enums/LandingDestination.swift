//
//  LandingDestination.swift
//  Boolti
//
//  Created by Miro on 4/5/24.
//

import Foundation

 enum LandingDestination: Codable {
     case reservationList
     case concertDetail(concertId: Int)
     // 추가될 예정
 }
