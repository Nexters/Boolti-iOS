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

    init?(_ rawValue: String){
        switch rawValue {
        case "발권 완료": // 발권 완료
            self  = .didTicketIssued
        case "입장 대기": // 입장 대기
            self = .concertWillStart
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
        }
    }
}
