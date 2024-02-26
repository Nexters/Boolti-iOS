//
//  TicketingConfirmDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/26/24.
//

import UIKit

final class TicketingConfirmDIContainer {

    private let concertRepository: ConcertRepository

    init(concertRepository: ConcertRepository) {
        self.concertRepository = concertRepository
    }

    func createTicketingConfirmViewController(ticketingEntity: TicketingEntity) -> TicketingConfirmViewController {
        let viewModel = createTicketingConfirmViewModel(ticketingEntity: ticketingEntity)
        
        let ticketingCompletionViewControllerFactory: (TicketingEntity) -> TicketingCompletionViewController = { ticketingEntity in
            let DIContainer = self.createTicketingCompletionDIContainer()

            let viewController = DIContainer.createTicketingCompletionViewController(ticketingEntity: ticketingEntity)
            return viewController
        }

        let viewController = TicketingConfirmViewController(
            viewModel: viewModel,
            ticketingCompletionViewControllerFactory: ticketingCompletionViewControllerFactory
        )
        
        return viewController
    }
    
    private func createTicketingCompletionDIContainer() -> TicketingCompletionDIContainer {
        return TicketingCompletionDIContainer(ticketReservationsRepository: TicketReservationRepository(networkService: self.concertRepository.networkService))
    }

    private func createTicketingConfirmViewModel(ticketingEntity: TicketingEntity) -> TicketingConfirmViewModel {
        return TicketingConfirmViewModel(concertRepository: self.concertRepository, ticketingEntity: ticketingEntity)
    }

}
