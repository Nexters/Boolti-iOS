//
//  TicketEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import Foundation

struct TicketEntity {
    // 일단 여러 티켓 살 수 없음을 가정해서 매수는 1개로 고정
    let id: Int
    let name: String
    let price: Int
    let inventory: Int
}
