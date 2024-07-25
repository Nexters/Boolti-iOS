//
//  TicketReservation.swift
//  Boolti
//
//  Created by Miro on 2/9/24.
//

import UIKit

enum ReservationStatus: String {
    case reservationCompleted = "RESERVATION_COMPLETED"
    case refundCompleted = "CANCELLED"
    case waitingForReceipt = "WAITING_FOR_GIFT_RECEIPT"

    var description: String {
        switch self {
        case .reservationCompleted: return "발권 완료"
        case .refundCompleted: return "취소 완료"
        case .waitingForReceipt: return "등록 대기"
        }
    }

    var color: UIColor {
        switch self {
        case .reservationCompleted: return .success
        case .refundCompleted: return .error
        case .waitingForReceipt: return .grey30
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
    let isGiftReservation: Bool
    let recipientName: String?
    let giftId: Int
    let csReservationID: String
}
