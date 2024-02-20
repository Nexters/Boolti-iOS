//
//  TicketReservationDetailDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

final class TicketReservationDetailDIContainer {

    typealias ReservationID = String

    private let ticketReservationRepository: TicketReservationsRepositoryType

    init(ticketReservationRepository: TicketReservationsRepositoryType) {
        self.ticketReservationRepository = ticketReservationRepository
    }

    func createTicketReservationDetailViewController(reservationID: String) -> TicketReservationDetailViewController {
        let ticketRefundReasonViewControllerFactory: (ReservationID) -> TicketRefundReasonViewController = { reservationID in
            let DIContainer = self.createTicketRefundReasonDIContainer()

            let viewController = DIContainer.createTicketRefundReasonViewController(reservationID: reservationID)

            return viewController
        }

        return TicketReservationDetailViewController(ticketRefundReasonlViewControllerFactory: ticketRefundReasonViewControllerFactory, viewModel: self.createTicketReservationDetailViewModel(reservationID: reservationID))
    }

    private func createTicketRefundReasonDIContainer() -> TicketRefundReasonDIContainer {
        return TicketRefundReasonDIContainer(ticketReservationsRepository: self.ticketReservationRepository)
    }

    private func createTicketReservationDetailViewModel(reservationID: String) -> TicketReservationDetailViewModel {
        return TicketReservationDetailViewModel(reservationID: reservationID, ticketReservationsRepository: ticketReservationRepository)
    }

}
