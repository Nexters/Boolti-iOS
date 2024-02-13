//
//  TicketRefundRequestDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import Foundation

final class TicketRefundRequestDIContainer {


    private let ticketReservationRepository: TicketReservationsRepositoryType

    init(ticketReservationRepository: TicketReservationsRepositoryType) {
        self.ticketReservationRepository = ticketReservationRepository
    }
    
    func createTicketRefundRequestViewController(reservationID: String, reasonText: String) -> TicketRefundRequestViewController {

        return TicketRefundRequestViewController(viewModel: self.ticketRefundRequestViewModel(reservationID: reservationID, reasonText: reasonText))
    }


    private func ticketRefundRequestViewModel(reservationID: String, reasonText: String) -> TicketRefundRequestViewModel {
        return TicketRefundRequestViewModel(reservationID: reservationID, reasonText: reasonText, ticketReservationsRepository: ticketReservationRepository)
    }

}
