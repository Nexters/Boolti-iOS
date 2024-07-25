//
//  TossPaymentsDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/20/24.
//

import UIKit

final class TossPaymentsDIContainer {
    
    private let ticketingRepository: TicketingRepository
    
    init(ticketingRepository: TicketingRepository) {
        self.ticketingRepository = ticketingRepository
    }
    
    func createTossPaymentsViewController(ticketingEntity: TicketingEntity? = nil,
                                          giftingEntity: GiftingEntity? = nil,
                                          type: TicketingType) -> TossPaymentViewController {
        let viewModel = TossPaymentsViewModel(ticketingRepository: self.ticketingRepository,
                                              giftingRepository: GiftingRepository(networkService: self.ticketingRepository.networkService),
                                              ticketingEntity: ticketingEntity,
                                              giftingEntity: giftingEntity,
                                              type: type)
        
        let viewController = TossPaymentViewController(viewModel: viewModel)
        
        return viewController
    }
    
}
