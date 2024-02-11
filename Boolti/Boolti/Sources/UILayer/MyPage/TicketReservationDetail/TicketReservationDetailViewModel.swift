//
//  TicketReservationDetailViewModel.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

final class TicketReservationDetailViewModel {

    private let ticketReservationsRepository: TicketReservationsRepositoryType
    private let reservationID: String

    init(reservationID: String, ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.reservationID = reservationID
        self.ticketReservationsRepository = ticketReservationsRepository
    }
}
