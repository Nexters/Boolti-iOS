//
//  TicketingCompletionDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit

final class TicketingCompletionDIContainer {

//    private let ticketAPIService: TicketAPIService
//
//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
//    }

    func createTicketingCompletionViewController(ticketingEntity: TicketingEntity) -> TicketingCompletionViewController {
        let viewModel = createTicketingCompletionViewModel(ticketingEntity: ticketingEntity)
        
        let viewController = TicketingCompletionViewController(
            viewModel: viewModel
        )
        
        return viewController
    }

    private func createTicketingCompletionViewModel(ticketingEntity: TicketingEntity) -> TicketingCompletionViewModel {
        return TicketingCompletionViewModel(ticketingEntity: ticketingEntity)
    }

}
