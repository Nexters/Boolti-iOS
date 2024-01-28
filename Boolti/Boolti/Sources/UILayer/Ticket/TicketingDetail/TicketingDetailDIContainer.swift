//
//  TicketingDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

final class TicketingDetailDIContainer {

//    private let ticketAPIService: TicketAPIService
//
//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
//    }

    func createTicketingDetailViewController() -> UIViewController {
        let viewModel = createTicketingDetailViewModel()
        
        let viewController = TicketingDetailViewController(
            viewModel: viewModel
        )
        
        return viewController
    }

    private func createTicketingDetailViewModel() -> TicketingDetailViewModel {
        return TicketingDetailViewModel()
    }

}
