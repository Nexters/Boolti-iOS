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

    func createTicketingDetailViewController(selectedTicket: TicketEntity) -> TicketingDetailViewController {
        let viewModel = createTicketingDetailViewModel(selectedTicket: selectedTicket)
        
        let viewController = TicketingDetailViewController(
            viewModel: viewModel
        )
        
        return viewController
    }

    private func createTicketingDetailViewModel(selectedTicket: TicketEntity) -> TicketingDetailViewModel {
        return TicketingDetailViewModel(selectedTicket: selectedTicket)
    }

}
