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
            self = .didTicketIssued
        default:
            return nil
        }
    }
}
