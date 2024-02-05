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

    func createTicketDetailController(ticketItem: TicketItem) -> TicketDetailViewController {
        let ticketEntryCodeViewControllerFactory = {
            let DIContainer = self.createTicketEntryCodeDIContainer()

            let viewController = DIContainer.createTicketEntryCodeViewController()
            return viewController
        }

        let viewController = TicketDetailViewController(
            ticketItem: ticketItem,
            viewModel: self.createTicketDetailViewModel(),
            ticketEntryCodeViewControllerFactory: ticketEntryCodeViewControllerFactory
        )

        return viewController
    }

    private func createTicketEntryCodeDIContainer() -> TicketEntryCodeDIContainer {
        return TicketEntryCodeDIContainer(networkService: self.networkService)
    }

    private func createTicketDetailViewModel() -> TicketDetailViewModel {
        return TicketDetailViewModel(networkService: self.networkService)
    }
}
