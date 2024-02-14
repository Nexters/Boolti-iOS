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
        return TicketingCompletionDIContainer(ticketReservationsRepository: TicketReservationRepository(networkService: self.concertRepository.networkService))
    }

    private func createTicketingDetailViewModel(selectedTicket: SelectedTicketEntity) -> TicketingDetailViewModel {
        return TicketingDetailViewModel(concertRepository: self.concertRepository, selectedTicket: selectedTicket)
    }

}
