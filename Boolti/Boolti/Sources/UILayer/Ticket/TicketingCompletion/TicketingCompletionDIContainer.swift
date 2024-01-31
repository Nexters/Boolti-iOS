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

    func createTicketingCompletionViewController() -> TicketingCompletionViewController {
        let viewModel = createTicketingCompletionViewModel()
        
        let viewController = TicketingCompletionViewController(
            viewModel: viewModel
        )
        
        return viewController
    }

    private func createTicketingCompletionViewModel() -> TicketingCompletionViewModel {
        return TicketingCompletionViewModel()
    }

}
