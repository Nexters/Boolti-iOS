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

    private let giftReservationRepository: ReservationRepositoryType

    init(giftReservationRepository: ReservationRepositoryType) {
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
        return TicketRefundReasonDIContainer(reservationRepository: self.giftReservationRepository)
    }

    private func createGiftReservationDetailViewModel(giftID: String) -> GiftReservationDetailViewModel {
        return GiftReservationDetailViewModel(giftID: giftID, giftReservationRepository: giftReservationRepository)
    }

}
