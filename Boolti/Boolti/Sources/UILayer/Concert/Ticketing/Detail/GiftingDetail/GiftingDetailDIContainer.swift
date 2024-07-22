//
//  GiftingDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 6/23/24.
//

final class GiftingDetailDIContainer {
    
    typealias GiftID = Int
    
    private let concertRepository: ConcertRepository
    
    init(concertRepository: ConcertRepository) {
        self.concertRepository = concertRepository
    }

    func createGiftingDetailViewController(selectedTicket: SelectedTicketEntity) -> GiftingDetailViewController {
        let viewModel = createGiftingDetailViewModel(selectedTicket: selectedTicket)
        
        let giftingConfirmViewControllerFactory: (GiftingEntity) -> GiftingConfirmViewController = { giftingEntity in
            let DIContainer = GiftingConfirmDIContainer(giftingRepository: GiftingRepository(networkService: self.concertRepository.networkService))

            let viewController = DIContainer.createGiftingConfirmViewController(giftingEntity: giftingEntity)
            return viewController
        }
        
        let tossPaymentsViewControllerFactory: (GiftingEntity) -> TossPaymentViewController = { giftingEntity in
            let DIContainer = TossPaymentsDIContainer(ticketingRepository: TicketingRepository(networkService: self.concertRepository.networkService))

            let viewController = DIContainer.createTossPaymentsViewController(giftingEntity: giftingEntity,
                                                                              type: .gifting)
            return viewController
        }
        
        let giftCompletionViewControllerFactory: (GiftID) ->  GiftCompletionViewController = { giftID in
            let DIContainer = GiftCompletionDIContainer(ticketReservationsRepository: TicketReservationRepository(networkService: self.concertRepository.networkService))

            let viewController = DIContainer.createGiftCompletionViewController(giftID: giftID)
            return viewController
        }
        
        let businessInfoViewControllerFactory = {
            let DIContainer = BusinessInfoDIContainer()
            let viewController = DIContainer.createBusinessInfoViewController()

            return viewController
        }

        let viewController = GiftingDetailViewController(viewModel: viewModel,
                                                         giftingConfirmViewControllerFactory: giftingConfirmViewControllerFactory,
                                                         tossPaymentsViewControllerFactory: tossPaymentsViewControllerFactory,
                                                         giftCompletionViewControllerFactory: giftCompletionViewControllerFactory,
                                                         businessInfoViewControllerFactory: businessInfoViewControllerFactory)
        
        return viewController
    }

    private func createGiftingDetailViewModel(selectedTicket: SelectedTicketEntity) -> GiftingDetailViewModel {
        return GiftingDetailViewModel(concertRepository: self.concertRepository,
                                      selectedTicket: selectedTicket)
    }

}
