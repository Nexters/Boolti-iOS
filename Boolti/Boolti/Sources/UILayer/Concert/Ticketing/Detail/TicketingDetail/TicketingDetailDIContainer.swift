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
    private let ticketReservationRepository: TicketReservationRepository

    typealias ReservationId = Int
    typealias GiftID = Int

    init(concertRepository: ConcertRepository) {
        self.concertRepository = concertRepository
        self.ticketingRepository = TicketingRepository(networkService: concertRepository.networkService)
        self.ticketReservationRepository = TicketReservationRepository(networkService: concertRepository.networkService)
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

        let giftCompletionViewControllerFactory: (GiftID) ->  GiftCompletionViewController = { giftID in
            let DIContainer = self.createGiftCompletionDIContainer()

            let viewController = DIContainer.createGiftCompletionViewController(giftID: giftID)
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
            giftCompletionViewControllerFactory: giftCompletionViewControllerFactory,
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
        return TicketingCompletionDIContainer(ticketReservationsRepository: ticketReservationRepository)
    }

    private func createGiftCompletionDIContainer() -> GiftCompletionDIContainer {
        return GiftCompletionDIContainer(ticketReservationsRepository: ticketReservationRepository)
    }

    private func createBusinessInfoDIContainer() -> BusinessInfoDIContainer {
        return BusinessInfoDIContainer()
    }
}
