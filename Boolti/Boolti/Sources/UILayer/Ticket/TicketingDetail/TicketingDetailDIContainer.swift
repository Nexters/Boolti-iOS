//
//  TicketingDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

final class TicketingDetailDIContainer {

//    private let ticketAPIService: TicketAPIService
//
//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
//    }

    func createTicketingDetailViewController(selectedTicket: TicketEntity) -> TicketingDetailViewController {
        let viewModel = createTicketingDetailViewModel(selectedTicket: selectedTicket)
        
        let ticketingCompletionViewControllerFactory: (TicketingEntity) -> TicketingCompletionViewController = { ticketingEntity in
            let DIContainer = self.createTicketingCompletionDIContainer()

            let viewController = DIContainer.createTicketingCompletionViewController(ticketingEntity: ticketingEntity)
            return viewController
        }

        let viewController = TicketingDetailViewController(
            viewModel: viewModel,
            ticketingCompletionViewControllerFactory: ticketingCompletionViewControllerFactory
        )
        
        return viewController
    }
    
    private func createTicketingCompletionDIContainer() -> TicketingCompletionDIContainer {
        return TicketingCompletionDIContainer()
    }

    private func createTicketingDetailViewModel(selectedTicket: TicketEntity) -> TicketingDetailViewModel {
        return TicketingDetailViewModel(selectedTicket: selectedTicket)
    }

}
