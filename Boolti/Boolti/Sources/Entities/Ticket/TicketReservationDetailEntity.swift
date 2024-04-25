//
//  TicketReservationDetailEntity.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

enum PaymentMethod: String {

    case accountTransfer = "ACCOUNT_TRANSFER"
    case card = "CARD"

    var description: String {
        switch self {
        case .accountTransfer: "계좌 이체"
        case .card: "카드 결제"
        }
    }
}

struct TicketReservationDetailEntity {

    let reservationID: String
    let concertPosterImageURLPath: String
    let concertTitle: String
    let salesTicketName: String
    let ticketType: TicketType
    let ticketCount: String
    let bankName: String
    let accountNumber: String
    let accountHolderName: String
    let depositDeadLine: String
    let paymentMethod: String
    let totalPaymentAmount: String
    let reservationStatus: ReservationStatus
    let ticketingDate: String?
    let purchaseName: String
    let purchaserPhoneNumber: String
    let depositorName: String
    let depositorPhoneNumber: String
    let salesEndTime: String
    let csReservationID: String
    let installmentPlanMonths: Int
    
}
