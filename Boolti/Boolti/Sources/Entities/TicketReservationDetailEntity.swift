//
//  TicketReservationDetailEntity.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

struct TicketReservationDetailEntity {

    let reservationID: String
    let concertPosterImageURLPath: String
    let concertTitle: String
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
}
