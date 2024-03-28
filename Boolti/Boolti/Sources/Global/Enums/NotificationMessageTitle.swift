//
//  NotificationMessageTitle.swift
//  Boolti
//
//  Created by Miro on 3/19/24.
//

import Foundation

enum NotificationMessageTitle {

    case didTicketIssued
    case concertWillStart
    case didrefundCompleted
    case despositRequest

    init?(_ rawValue: String){
        switch rawValue {
        case "RESERVATION_COMPLETED": // 발권 완료
            self  = .didTicketIssued
        case "ENTER_NOTIFICATION": // 입장 대기
            self = .concertWillStart
        case "DEPOSIT_REQUEST": // 입금 요청
            self = .despositRequest
        case "REFUND_COMPLETED": // 환불 완료
            self = .didrefundCompleted
        default:
            return nil
        }
    }

    var tabBarIndex: Int {
        switch self {
        case .didTicketIssued:
            return 1
        case .concertWillStart:
            return 1
        case .didrefundCompleted:
            return 2
        case .despositRequest:
            return 0
        }
    }
}
