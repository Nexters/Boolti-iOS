//
//  TicketingConfirmDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/26/24.
//

import UIKit

final class TicketingConfirmDIContainer {

    private let ticketingRepository: TicketingRepository

    init(ticketingRepository: TicketingRepository) {
        self.ticketingRepository = ticketingRepository
    }

    func createTicketingConfirmViewController(ticketingEntity: TicketingEntity) -> TicketingConfirmViewController {
        let viewModel = createTicketingConfirmViewModel(ticketingEntity: ticketingEntity)

        let viewController = TicketingConfirmViewController(viewModel: viewModel)
        
        return viewController
    }

    private func createTicketingConfirmViewModel(ticketingEntity: TicketingEntity) -> TicketingConfirmViewModel {
        return TicketingConfirmViewModel(ticketingRepository: self.ticketingRepository, ticketingEntity: ticketingEntity)
    }

}
