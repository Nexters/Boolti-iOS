//
//  TicketReservationDetailDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

final class TicketReservationDetailDIContainer {

    typealias ReservationID = String

    private let reservationRepository: ReservationRepositoryType

    init(reservationRepository: ReservationRepositoryType) {
        self.reservationRepository = reservationRepository
    }

    func createTicketReservationDetailViewController(reservationID: String) -> TicketReservationDetailViewController {
        let ticketRefundReasonViewControllerFactory: (ReservationID) -> TicketRefundReasonViewController = { reservationID in
            let DIContainer = self.createTicketRefundReasonDIContainer()

            let viewController = DIContainer.createTicketRefundReasonViewController(reservationID: reservationID)
 
            return viewController
        }

        return TicketReservationDetailViewController(ticketRefundReasonViewControllerFactory: ticketRefundReasonViewControllerFactory, viewModel: self.createTicketReservationDetailViewModel(reservationID: reservationID))
    }

    private func createTicketRefundReasonDIContainer() -> TicketRefundReasonDIContainer {
        return TicketRefundReasonDIContainer(reservationRepository: self.reservationRepository)
    }

    private func createTicketReservationDetailViewModel(reservationID: String) -> TicketReservationDetailViewModel {
        return TicketReservationDetailViewModel(reservationID: reservationID, reservationRepository: reservationRepository)
    }

}
