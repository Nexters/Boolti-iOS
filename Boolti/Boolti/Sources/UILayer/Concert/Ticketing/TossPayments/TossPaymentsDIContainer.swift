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

    func createTossPaymentsViewController(ticketingEntity: TicketingEntity) -> TossPaymentViewController {
        let viewModel = createTossPaymentsViewModel(ticketingEntity: ticketingEntity)

        let viewController = TossPaymentViewController(viewModel: viewModel)
        
        return viewController
    }

    private func createTossPaymentsViewModel(ticketingEntity: TicketingEntity) -> TossPaymentsViewModel {
        return TossPaymentsViewModel(ticketingRepository: self.ticketingRepository, ticketingEntity: ticketingEntity)
    }

}
