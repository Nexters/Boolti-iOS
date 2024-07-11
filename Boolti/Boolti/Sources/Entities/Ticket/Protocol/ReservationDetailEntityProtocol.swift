//
//  ReservationDetailEntityProtocol.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import Foundation

protocol ReservationDetailEntityProtocol {

    var reservationID: Int { get }
    var concertPosterImageURLPath: String { get }
    var concertTitle: String { get }
    var salesTicketName: String { get }
    var ticketType: TicketType { get }
    var ticketCount: Int { get }
    var depositDeadLine: String { get }
    var paymentMethod: PaymentMethod? { get }
    var totalPaymentAmount: String { get }
    var reservationStatus: ReservationStatus { get }
    var ticketingDate: String? { get }
    var salesEndTime: String { get }
    var csReservationID: String { get }
    var easyPayProvider: String? { get }
    var accountTransferBank: String? { get }
    var paymentCardDetail: PaymentCardDetail? { get }
    var showDate: Date { get }
}
