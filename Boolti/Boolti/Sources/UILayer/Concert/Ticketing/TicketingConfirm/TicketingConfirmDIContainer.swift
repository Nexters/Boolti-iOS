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

        let viewController = TicketingConfirmViewController(viewModel: viewModel)
        
        return viewController
    }

    private func createTicketingConfirmViewModel(ticketingEntity: TicketingEntity) -> TicketingConfirmViewModel {
        return TicketingConfirmViewModel(concertRepository: self.concertRepository, ticketingEntity: ticketingEntity)
    }

}
