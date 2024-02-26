//
//  TicketingDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

final class TicketingDetailDIContainer {

    private let concertRepository: ConcertRepository

    init(concertRepository: ConcertRepository) {
        self.concertRepository = concertRepository
    }

    func createTicketingDetailViewController(selectedTicket: SelectedTicketEntity) -> TicketingDetailViewController {
        let viewModel = createTicketingDetailViewModel(selectedTicket: selectedTicket)
        
        let ticketingConfirmViewControllerFactory: (TicketingEntity) -> TicketingConfirmViewController = { ticketingEntity in
            let DIContainer = self.createTicketingConfirmDIContainer()

            let viewController = DIContainer.createTicketingConfirmViewController(ticketingEntity: ticketingEntity)
            return viewController
        }

        let viewController = TicketingDetailViewController(
            viewModel: viewModel,
            ticketingConfirmViewControllerFactory: ticketingConfirmViewControllerFactory
        )
        
        return viewController
    }
    
    private func createTicketingConfirmDIContainer() -> TicketingConfirmDIContainer {
        return TicketingConfirmDIContainer(concertRepository: self.concertRepository)
    }

    private func createTicketingDetailViewModel(selectedTicket: SelectedTicketEntity) -> TicketingDetailViewModel {
        return TicketingDetailViewModel(concertRepository: self.concertRepository, selectedTicket: selectedTicket)
    }

}
