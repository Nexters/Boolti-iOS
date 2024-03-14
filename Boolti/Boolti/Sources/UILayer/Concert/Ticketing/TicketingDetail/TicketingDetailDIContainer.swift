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
        
        let ticketingCompletionViewControllerFactory: (TicketingEntity) -> TicketingCompletionViewController = { ticketingEntity in
            let DIContainer = self.createTicketingCompletionDIContainer()

            let viewController = DIContainer.createTicketingCompletionViewController(ticketingEntity: ticketingEntity)
            return viewController
        }
        
        let businessInfoViewControllerFactory = {
            let DIContainer = self.createBusinessInfoDIContainer()
            let viewController = DIContainer.createBusinessInfoViewController()

            return viewController
        }

        let viewController = TicketingDetailViewController(
            viewModel: viewModel,
            ticketingConfirmViewControllerFactory: ticketingConfirmViewControllerFactory,
            ticketingCompletionViewControllerFactory: ticketingCompletionViewControllerFactory,
            businessInfoViewControllerFactory: businessInfoViewControllerFactory
        )
        
        return viewController
    }
    
    private func createTicketingConfirmDIContainer() -> TicketingConfirmDIContainer {
        return TicketingConfirmDIContainer(concertRepository: self.concertRepository)
    }

    private func createTicketingDetailViewModel(selectedTicket: SelectedTicketEntity) -> TicketingDetailViewModel {
        return TicketingDetailViewModel(concertRepository: self.concertRepository, selectedTicket: selectedTicket)
    }
    
    private func createTicketingCompletionDIContainer() -> TicketingCompletionDIContainer {
        return TicketingCompletionDIContainer(ticketReservationsRepository: TicketReservationRepository(networkService: self.concertRepository.networkService))
    }
    
    private func createBusinessInfoDIContainer() -> BusinessInfoDIContainer {
        return BusinessInfoDIContainer()
    }
}
