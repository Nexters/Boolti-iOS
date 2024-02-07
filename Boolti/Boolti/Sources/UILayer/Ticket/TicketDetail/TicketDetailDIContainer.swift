//
//  TicketDetailDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import Foundation

class TicketDetailDIContainer {
    
    // 일단 필요할 지는 모르겠으나! authAPIService
    private let authAPIService: AuthAPIServiceType
    private let networkService: NetworkProviderType

    init(authAPIService: AuthAPIServiceType) {
        self.authAPIService = authAPIService
        self.networkService = authAPIService.networkService
    }

    func createTicketDetailController(ticketID: String) -> TicketDetailViewController {
        let ticketEntryCodeViewControllerFactory = {
            let DIContainer = self.createTicketEntryCodeDIContainer()

            let viewController = DIContainer.createTicketEntryCodeViewController()
            return viewController
        }

        let viewController = TicketDetailViewController(
            viewModel: self.createTicketDetailViewModel(ticketID: ticketID),
            ticketEntryCodeViewControllerFactory: ticketEntryCodeViewControllerFactory
        )

        return viewController
    }

    private func createTicketEntryCodeDIContainer() -> TicketEntryCodeDIContainer {
        return TicketEntryCodeDIContainer(networkService: self.networkService)
    }

    private func createTicketDetailViewModel(ticketID: String) -> TicketDetailViewModel {
        return TicketDetailViewModel(ticketID: ticketID, networkService: self.networkService)
    }
}
