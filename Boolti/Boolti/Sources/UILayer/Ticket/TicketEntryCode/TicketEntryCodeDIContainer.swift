//
//  TicketEntryCodeDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import Foundation

class TicketEntryCodeDIContainer {

    private let networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    func createTicketEntryCodeViewController(ticketID: String, concertID: String) -> TicketEntryCodeViewController {
        let viewController = TicketEntryCodeViewController(viewModel: self.ticketEntryCodeViewModel(ticketID: ticketID, concertID: concertID))

        return viewController
    }

    private func ticketEntryCodeViewModel(ticketID: String, concertID: String) -> TicketEntryCodeViewModel {
        return TicketEntryCodeViewModel(ticketID: ticketID, concertID: concertID, networkService: self.networkService)
    }
}
