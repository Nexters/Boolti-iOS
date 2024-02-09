//
//  TicketReservation.swift
//  Boolti
//
//  Created by Miro on 2/9/24.
//

import UIKit

enum ReservationStatus: String {
    case waitingForDeposit = "입금 확인 중"
    case cancelled = "취소"
    case reservationCompleted = "티켓 발권 완료"
    case waitingForRefund = "환불 진행 중"
    case refundCompleted = "환불 완료"
    

    // 색깔은 바뀔 예정
    var color: UIColor {
        switch self {
        case .waitingForDeposit: return .grey30
        case .cancelled: return .error
        case .waitingForRefund: return .grey30
        case .reservationCompleted: return .success
        case .refundCompleted: return .green
        }
    }
}

struct TicketReservationEntity {
    let reservationID: Int
    let reservationStatus: ReservationStatus
    let reservationDate: String
    let concertTitle: String
    let concertImageURLPath: String
    let ticketName: String
    let ticketCount: Int
    let ticketPrice: Int
}
