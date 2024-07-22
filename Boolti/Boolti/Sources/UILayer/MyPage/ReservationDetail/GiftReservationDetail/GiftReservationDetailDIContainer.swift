//
//  GiftReservationDetailDIContainer.swift
//  Boolti
//
//  Created by Miro on 7/22/24.
//

import Foundation


import Foundation

final class GiftReservationDetailDIContainer {

    typealias giftID = String

    private let giftReservationRepository: TicketReservationsRepositoryType

    init(giftReservationRepository: TicketReservationsRepositoryType) {
        self.giftReservationRepository = giftReservationRepository
    }

    func createTicketReservationDetailViewController(giftID: String) -> GiftReservationDetailViewController {
        let ticketRefundReasonViewControllerFactory: (giftID) -> TicketRefundReasonViewController = { reservationID in
            let DIContainer = self.createTicketRefundReasonDIContainer()

            let viewController = DIContainer.createTicketRefundReasonViewController(reservationID: reservationID)

            return viewController
        }

        return GiftReservationDetailViewController(ticketRefundReasonViewControllerFactory: ticketRefundReasonViewControllerFactory, viewModel: self.createGiftReservationDetailViewModel(giftID: giftID))
    }

    private func createTicketRefundReasonDIContainer() -> TicketRefundReasonDIContainer {
        return TicketRefundReasonDIContainer(ticketReservationsRepository: self.giftReservationRepository)
    }

    private func createGiftReservationDetailViewModel(giftID: String) -> GiftReservationDetailViewModel {
        return GiftReservationDetailViewModel(giftID: giftID, giftReservationsRepository: giftReservationRepository)
    }

}
