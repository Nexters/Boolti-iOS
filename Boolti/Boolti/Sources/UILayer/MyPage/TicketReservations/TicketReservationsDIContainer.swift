//
//  TicketReservationsDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class TicketReservationsDIContainer {

    typealias ReservationID = String
    typealias GiftID = String


    private let ticketReservationsRepository: TicketReservationsRepositoryType

    init(networkService: NetworkProviderType) {
        self.ticketReservationsRepository = TicketReservationRepository(networkService: networkService)
    }

    func createTicketReservationsViewController() -> TicketReservationsViewController {
        let ticketReservationDetailViewControllerFactory: (ReservationID) -> TicketReservationDetailViewController = { reservationID in
            let DIContainer = self.createTicketReservationDetailDIContainer()

            let viewController = DIContainer.createTicketReservationDetailViewController(reservationID: reservationID)

            return viewController
        }

        let giftReservationDetailViewControllerFactory: (GiftID) -> GiftReservationDetailViewController = { giftID in
            let DIContainer = self.createGiftReservationDetailDIContainer()

            let viewController = DIContainer.createTicketReservationDetailViewController(giftID: giftID)

            return viewController
        }



        return TicketReservationsViewController(
            ticketReservationDetailViewControllerFactory: ticketReservationDetailViewControllerFactory,
            giftReservationDetailViewControllerFactory: giftReservationDetailViewControllerFactory,
            viewModel: self.createTicketResercationsViewModel())
    }

    private func createTicketResercationsViewModel() -> TicketReservationsViewModel {
        return TicketReservationsViewModel(
            ticketReservationsRepository: self.ticketReservationsRepository)
    }

    private func createTicketReservationDetailDIContainer() -> TicketReservationDetailDIContainer {
        return TicketReservationDetailDIContainer(ticketReservationRepository: self.ticketReservationsRepository)
    }

    private func createGiftReservationDetailDIContainer() -> GiftReservationDetailDIContainer {
        return GiftReservationDetailDIContainer(giftReservationRepository: self.ticketReservationsRepository)
    }
}
