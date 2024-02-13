//
//  TicketRefundRequestViewModel.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import Foundation

final class TicketRefundRequestViewModel {
    
    private let reservationID: String
    private let reasonText: String
    private let ticketReservationsRepository: TicketReservationsRepositoryType

    init(reservationID: String, reasonText: String, ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.reservationID = reservationID
        self.reasonText = reasonText
        self.ticketReservationsRepository = ticketReservationsRepository
    }
}
