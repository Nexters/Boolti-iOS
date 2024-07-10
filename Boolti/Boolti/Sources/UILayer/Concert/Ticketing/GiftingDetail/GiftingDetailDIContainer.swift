//
//  GiftingDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 6/23/24.
//

final class GiftingDetailDIContainer {
    
    private let concertRepository: ConcertRepository
    
    init(concertRepository: ConcertRepository) {
        self.concertRepository = concertRepository
    }

    func createGiftingDetailViewController(selectedTicket: SelectedTicketEntity) -> GiftingDetailViewController {
        let viewModel = createGiftingDetailViewModel(selectedTicket: selectedTicket)
        
        let businessInfoViewControllerFactory = {
            let DIContainer = BusinessInfoDIContainer()
            let viewController = DIContainer.createBusinessInfoViewController()

            return viewController
        }

        let viewController = GiftingDetailViewController(viewModel: viewModel, businessInfoViewControllerFactory: businessInfoViewControllerFactory)
        
        return viewController
    }

    private func createGiftingDetailViewModel(selectedTicket: SelectedTicketEntity) -> GiftingDetailViewModel {
        return GiftingDetailViewModel(concertRepository: self.concertRepository,
                                      selectedTicket: selectedTicket)
    }

}
