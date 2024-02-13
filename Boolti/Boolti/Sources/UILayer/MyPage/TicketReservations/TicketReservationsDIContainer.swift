//
//  TicketReservationsDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class TicketReservationsDIContainer {

    typealias ReservationID = String

    private let ticketReservationsRepository: TicketReservationsRepositoryType

    init(networkService: NetworkProviderType) {
        self.ticketReservationsRepository = TicketReservationRepository(networkService: networkService)
    }

    func createTicketReservationsViewController() -> TicketReservationsViewController {
        let ticketReservationsViewControllerFactory: (ReservationID) -> TicketReservationDetailViewController = { reservationID in
            let DIContainer = self.createTicketReservationDetailDIContainer()

            let viewController = DIContainer.createTicketReservationDetailViewController(reservationID: reservationID)

            return viewController
        }

        return TicketReservationsViewController(ticketReservationDetailViewControllerFactory: ticketReservationsViewControllerFactory, viewModel: self.createTicketResercationsViewModel())
    }

    private func createTicketResercationsViewModel() -> TicketReservationsViewModel {
        return TicketReservationsViewModel(
            ticketReservationsRepository: self.ticketReservationsRepository)
    }

    private func createTicketReservationDetailDIContainer() -> TicketReservationDetailDIContainer {
        return TicketReservationDetailDIContainer(ticketReservationRepository: self.ticketReservationsRepository)
    }
}
