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

    func createTicketEntryCodeViewController() -> TicketEntryCodeViewController {
        let viewController = TicketEntryCodeViewController(viewModel: self.ticketEntryCodeViewModel())

        return viewController
    }

    private func ticketEntryCodeViewModel() -> TicketEntryCodeViewModel {
        return TicketEntryCodeViewModel(networkService: self.networkService)
    }
}
