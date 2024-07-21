//
//  TicketingDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

final class TicketingDetailDIContainer {

    private let concertRepository: ConcertRepository
    private let ticketingRepository: TicketingRepository
    
    typealias ReservationId = Int

    init(concertRepository: ConcertRepository) {
        self.concertRepository = concertRepository
        self.ticketingRepository = TicketingRepository(networkService: concertRepository.networkService)
    }

    func createTicketingDetailViewController(selectedTicket: SelectedTicketEntity) -> TicketingDetailViewController {
        let viewModel = createTicketingDetailViewModel(selectedTicket: selectedTicket)
        
        let ticketingConfirmViewControllerFactory: (TicketingEntity) -> TicketingConfirmViewController = { ticketingEntity in
            let DIContainer = self.createTicketingConfirmDIContainer()

            let viewController = DIContainer.createTicketingConfirmViewController(ticketingEntity: ticketingEntity)
            return viewController
        }
        
        let tossPaymentsViewControllerFactory: (TicketingEntity) -> TossPaymentViewController = { ticketingEntity in
            let DIContainer = self.createTossPaymentsDIContainer()
            
            let viewController = DIContainer.createTossPaymentsViewController(ticketingEntity: ticketingEntity)
            return viewController
        }
        
        let ticketingCompletionViewControllerFactory: (ReservationId) -> TicketingCompletionViewController = { reservationId in
            let DIContainer = self.createTicketingCompletionDIContainer()

            let viewController = DIContainer.createTicketingCompletionViewController(reservationId: reservationId)
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
            tossPaymentsViewControllerFactory: tossPaymentsViewControllerFactory,
            ticketingCompletionViewControllerFactory: ticketingCompletionViewControllerFactory,
            businessInfoViewControllerFactory: businessInfoViewControllerFactory
        )
        
        return viewController
    }
    
    private func createTicketingConfirmDIContainer() -> TicketingConfirmDIContainer {
        return TicketingConfirmDIContainer(ticketingRepository: self.ticketingRepository)
    }
    
    private func createTossPaymentsDIContainer() -> TossPaymentsDIContainer {
        return TossPaymentsDIContainer(ticketingRepository: self.ticketingRepository)
    }
    
    private func createTicketingDetailViewModel(selectedTicket: SelectedTicketEntity) -> TicketingDetailViewModel {
        return TicketingDetailViewModel(ticketingRepository: self.ticketingRepository,
                                        concertRepository: self.concertRepository,
                                        selectedTicket: selectedTicket)
    }
    
    private func createTicketingCompletionDIContainer() -> TicketingCompletionDIContainer {
        return TicketingCompletionDIContainer(ticketReservationsRepository: TicketReservationRepository(networkService: self.concertRepository.networkService))
    }
    
    private func createBusinessInfoDIContainer() -> BusinessInfoDIContainer {
        return BusinessInfoDIContainer()
    }
}
