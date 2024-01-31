//
//  TicketSelectionDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit

final class TicketSelectionDIContainer {

//    private let ticketAPIService: TicketAPIService
//
//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
//    }

    func createTicketSelectionViewController() -> UIViewController {
        let viewModel = createTicketSelectionViewModel()
        
        let ticketingDetailViewControllerFactory: (TicketEntity) -> TicketingDetailViewController = { selectedTicket in
            let DIContainer = self.createTicketingDetailViewDIContainer()

            let viewController = DIContainer.createTicketingDetailViewController(selectedTicket: selectedTicket)
            return viewController
        }
        
        let viewController = TicketSelectionViewController(
            viewModel: viewModel, ticketingDetailViewControllerFactory: ticketingDetailViewControllerFactory
        )
        
        return viewController
    }
    
    private func createTicketingDetailViewDIContainer() -> TicketingDetailDIContainer {
        return TicketingDetailDIContainer()
    }

    private func createTicketSelectionViewModel() -> TicketSelectionViewModel {
        return TicketSelectionViewModel()
    }

}
