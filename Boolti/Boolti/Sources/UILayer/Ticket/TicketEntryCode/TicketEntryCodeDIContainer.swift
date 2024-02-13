//
//  TicketEntryCodeDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import Foundation

class TicketEntryCodeDIContainer {

    private let networkService: NetworkProviderType
    private let ticketID: String
    private let concertID: String

    init(ticketID: String, concertID: String, networkService: NetworkProviderType) {
        self.ticketID = ticketID
        self.concertID = concertID
        self.networkService = networkService
    }

    func createTicketEntryCodeViewController() -> TicketEntryCodeViewController {
        let viewController = TicketEntryCodeViewController(viewModel: self.ticketEntryCodeViewModel())

        return viewController
    }

    private func ticketEntryCodeViewModel() -> TicketEntryCodeViewModel {
        return TicketEntryCodeViewModel(ticketID: self.ticketID, concertID: self.concertID, networkService: self.networkService)
    }
}
