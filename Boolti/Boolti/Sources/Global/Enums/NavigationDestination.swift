//
//  NavigationDestination.swift
//  Boolti
//
//  Created by Miro on 4/5/24.
//

import Foundation

// 이름도 변경해야될듯?!..
 enum NavigationDestination: Codable {
     case reservationList
     case concertDetail(concertId: Int)
     // 추가될 예정
 }
