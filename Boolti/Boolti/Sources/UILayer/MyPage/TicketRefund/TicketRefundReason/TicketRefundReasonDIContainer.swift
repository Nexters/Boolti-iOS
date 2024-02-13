//
//  TicketRefundReasonDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import Foundation

final class TicketRefundReasonDIContainer {

    private let ticketReservationsRepository: TicketReservationsRepositoryType

    init(ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.ticketReservationsRepository = ticketReservationsRepository
    }

    func createTicketRefundReasonViewController(reservationID: String) -> TicketRefundReasonViewController {
        return TicketRefundReasonViewController(viewModel: self.createTicketRefundReasonViewModel(reservationID: reservationID))
    }

    func createTicketRefundReasonViewModel(reservationID: String) -> TicketRefundReasonViewModel {
        return TicketRefundReasonViewModel(reservationID: reservationID)
    }
}
