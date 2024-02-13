//
//  TicketReservationDetailDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

final class TicketReservationDetailDIContainer {

    private let ticketReservationRepository: TicketReservationsRepositoryType

    init(ticketReservationRepository: TicketReservationsRepositoryType) {
        self.ticketReservationRepository = ticketReservationRepository
    }

    func createTicketReservationDetailViewController(reservationID: String) -> TicketReservationDetailViewController {
        return TicketReservationDetailViewController(viewModel: self.createTicketReservationDetailViewModel(reservationID: reservationID))
    }

    func createTicketReservationDetailViewModel(reservationID: String) -> TicketReservationDetailViewModel {
        return TicketReservationDetailViewModel(reservationID: reservationID, ticketReservationsRepository: ticketReservationRepository)
    }

}
