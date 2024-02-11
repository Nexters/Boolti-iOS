//
//  TicketSelectionDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit

final class TicketSelectionDIContainer {

    private let concertRepository: ConcertRepository

    init(concertRepository: ConcertRepository) {
        self.concertRepository = concertRepository
    }

    func createTicketSelectionViewController(concertId: Int) -> TicketSelectionViewController {
        let viewModel = createTicketSelectionViewModel(concertId: concertId)
        
        let ticketingDetailViewControllerFactory: (SalesTicketEntity) -> TicketingDetailViewController = { selectedTicket in
            let DIContainer = self.createTicketingDetailViewDIContainer()

            let viewController = DIContainer.createTicketingDetailViewController(selectedTicket: selectedTicket)
            return viewController
        }
        
        let viewController = TicketSelectionViewController(
            viewModel: viewModel,
            ticketingDetailViewControllerFactory: ticketingDetailViewControllerFactory
        )
        
        return viewController
    }
    
    private func createTicketingDetailViewDIContainer() -> TicketingDetailDIContainer {
        return TicketingDetailDIContainer(concertRepository: self.concertRepository)
    }

    private func createTicketSelectionViewModel(concertId: Int) -> TicketSelectionViewModel {
        return TicketSelectionViewModel(concertRepository: self.concertRepository,
                                        concertId: concertId)
    }

}
