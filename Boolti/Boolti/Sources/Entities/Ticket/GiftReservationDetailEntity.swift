//
//  GiftReservationDetailEntity.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import Foundation

struct GiftReservationDetailEntity: ReservationDetailEntityProtocol {

    let concertPosterImageURLPath: String
    let concertTitle: String
    let salesTicketName: String
    let ticketType: TicketType
    let ticketCount: Int
    let depositDeadLine: String
    let paymentMethod: PaymentMethod?
    let totalPaymentAmount: String
    let reservationStatus: ReservationStatus
    let ticketingDate: String?
    let salesEndTime: String
    let csReservationID: String
    let easyPayProvider: String?
    let accountTransferBank: String?
    let paymentCardDetail: PaymentCardDetail?
    let showDate: Date

    let giftID: Int
    let giftUuid: Int
    let giftMessage: String
    let giftImageURLPath: String
    let recipientName: String
    let recipientPhoneNumber: String
    let senderName: String
    let senderPhoneNumber: String
}
