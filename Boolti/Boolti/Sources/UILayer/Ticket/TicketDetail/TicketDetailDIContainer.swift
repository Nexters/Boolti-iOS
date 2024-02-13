//
//  TicketDetailDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import Foundation

class TicketDetailDIContainer {

    // 일단 필요할 지는 모르겠으나! authRepository
    private let authRepository: AuthRepositoryType
    private let networkService: NetworkProviderType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
        self.networkService = authRepository.networkService
    }

    func createTicketDetailController(ticketID: String) -> TicketDetailViewController {
        let ticketEntryCodeViewControllerFactory = { (ticketID: String, concertID: String) in
            let DIContainer = self.createTicketEntryCodeDIContainer(ticketID: ticketID, concertID: concertID)

            let viewController = DIContainer.createTicketEntryCodeViewController()
            return viewController
        }

        let viewController = TicketDetailViewController(
            viewModel: self.createTicketDetailViewModel(ticketID: ticketID),
            ticketEntryCodeViewControllerFactory: ticketEntryCodeViewControllerFactory
        )

        return viewController
    }

    private func createTicketEntryCodeDIContainer(ticketID: String, concertID: String) -> TicketEntryCodeDIContainer {
        return TicketEntryCodeDIContainer(ticketID: ticketID, concertID: concertID, networkService: self.networkService)
    }

    private func createTicketDetailViewModel(ticketID: String) -> TicketDetailViewModel {
        return TicketDetailViewModel(ticketID: ticketID, networkService: self.networkService)
    }
}
