//
//  TicketReservationsDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class TicketReservationsDIContainer {

    private let networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    func createTicketReservationsViewController() -> TicketReservationsViewController {
        return TicketReservationsViewController(viewModel: self.createTicketResercationsViewModel())
    }

    private func createTicketResercationsViewModel() -> TicketReservationsViewModel {
        return TicketReservationsViewModel(
            ticketReservationsRepository: TicketReservationRepository(networkService: self.networkService)
        )
    }
}
