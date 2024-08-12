//
//  TicketRefundReasonDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import Foundation

final class TicketRefundReasonDIContainer {

    typealias ReservationID = String
    typealias ReasonText = String

    private let reservationRepository: ReservationRepositoryType

    init(reservationRepository: ReservationRepositoryType) {
        self.reservationRepository = reservationRepository
    }

    func createTicketRefundReasonViewController(reservationID: String) -> TicketRefundReasonViewController {

        let ticketRefundRequestViewControllerFactory: (ReservationID, ReasonText) -> TicketRefundRequestViewController = {
            (reaservationID, reasonText) in
            let DIContainer = self.createTicketRefundRequestDIContainer()
            let viewController = DIContainer.createTicketRefundRequestViewController(reservationID: reservationID, reasonText: reasonText)

            return viewController
        }

        return TicketRefundReasonViewController(
            ticketRefundRequestViewControllerFactory: ticketRefundRequestViewControllerFactory,
            viewModel: self.createTicketRefundReasonViewModel(reservationID: reservationID)
        )
    }

    func createTicketRefundReasonViewModel(reservationID: String) -> TicketRefundReasonViewModel {
        return TicketRefundReasonViewModel(reservationID: reservationID)
    }

    private func createTicketRefundRequestDIContainer() -> TicketRefundRequestDIContainer {
        return TicketRefundRequestDIContainer(reservationRepository: self.reservationRepository)
    }
}
