//
//  TicketReservation.swift
//  Boolti
//
//  Created by Miro on 2/9/24.
//

import UIKit

enum ReservationStatus: String {
    case waitingForDeposit = "WAITING_FOR_DEPOSIT"
    case cancelled = "CANCELLED"
    case reservationCompleted = "RESERVATION_COMPLETED"
    case waitingForRefund = "WAITING_FOR_REFUND"
    case refundCompleted = "REFUND_COMPLETED"

    var description: String {
        switch self {
        case .waitingForDeposit: return "입금 확인 중"
        case .cancelled: return "취소"
        case .reservationCompleted: return "티켓 발권 완료"
        case .waitingForRefund: return "환불 진행 중"
        case .refundCompleted: return "환불 완료"
        }
    }

    var color: UIColor {
        switch self {
        case .waitingForDeposit: return .grey30
        case .cancelled: return .error
        case .waitingForRefund: return .grey30
        case .reservationCompleted: return .success
        case .refundCompleted: return .error
        }
    }
}

struct TicketReservationItemEntity {
    let reservationID: Int
    let reservationStatus: ReservationStatus
    let reservationDate: String
    let concertTitle: String
    let concertImageURLPath: String
    let ticketName: String
    let ticketCount: Int
    let ticketPrice: Int
    let csReservationID: String
}
