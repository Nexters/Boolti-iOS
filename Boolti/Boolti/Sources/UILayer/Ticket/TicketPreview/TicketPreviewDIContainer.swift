//
//  TicketPreviewDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

final class TicketPreviewDIContainer {

//    private let ticketAPIService: TicketAPIService
//
//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
//    }

    func createTicketPreviewViewController() -> UIViewController {
        let viewModel = createTicketPreviewViewModel()
        
        let viewController = TicketPreviewViewController(
            viewModel: viewModel
        )
        
        return viewController
    }

    private func createTicketPreviewViewModel() -> TicketPreviewViewModel {
        return TicketPreviewViewModel()
    }

}
