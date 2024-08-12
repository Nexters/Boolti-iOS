//
//  TicketRefundRequestDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import Foundation

final class TicketRefundRequestDIContainer {

    typealias ReservationID = String
    typealias ReasonText = String

    private let reservationRepository: ReservationRepositoryType

    init(reservationRepository: ReservationRepositoryType) {
        self.reservationRepository = reservationRepository
    }
    
    func createTicketRefundRequestViewController(reservationID: String, reasonText: String) -> TicketRefundRequestViewController {

        let ticketRefundConfirmViewControllerFactory: (ReservationID, ReasonText?, RefundAccountInformation, Bool) -> TicketRefundConfirmViewController = {
            (reservationID, reasonText, refundAccountInformation, isGift) in

            let DIContainer = self.createTicketRefundConfirmDIContainer()
            let viewController = DIContainer.createTicketRefundConfirmViewController(reservationID: reservationID, reasonText: reasonText, isGift: isGift, refundAccoundInformation: refundAccountInformation)

            return viewController
        }

        return TicketRefundRequestViewController(
            ticketRefundConfirmViewControllerFactory: ticketRefundConfirmViewControllerFactory,
            viewModel: self.ticketRefundRequestViewModel(reservationID: reservationID, reasonText: reasonText)
        )
    }


    private func ticketRefundRequestViewModel(reservationID: String, reasonText: String) -> TicketRefundRequestViewModel {
        return TicketRefundRequestViewModel(reservationID: reservationID, reasonText: reasonText, reservationRepository: reservationRepository)
    }

    private func createTicketRefundConfirmDIContainer() -> TicketRefundConfirmDIContainer {
        return TicketRefundConfirmDIContainer(reservationRepository: self.reservationRepository)
    }
}
