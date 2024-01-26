//
//  TicketSelectionDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit

final class TicketSelectionDIContainer {

//    private let ticketAPIService: TicketAPIService
//
//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
//    }

    func createTicketSelectionViewController() -> UIViewController {
        let viewModel = createTicketSelectionViewModel()
        
        let viewController = TicketSelectionViewController(
            viewModel: viewModel
        )
        
        return viewController
    }

    private func createTicketSelectionViewModel() -> TicketSelectionViewModel {
        return TicketSelectionViewModel()
    }

}
