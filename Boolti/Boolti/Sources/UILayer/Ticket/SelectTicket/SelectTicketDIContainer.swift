//
//  SelectTicketDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit

final class SelectTicketDIContainer {

//    private let ticketAPIService: TicketAPIService
//
//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
//    }

    func createSelectTicketViewController() -> UIViewController {
        let viewModel = createSelectTicketViewModel()
        
        let viewController = SelectTicketViewController(
            viewModel: viewModel
        )
        
        return viewController
    }

    private func createSelectTicketViewModel() -> SelectTicketViewModel {
        return SelectTicketViewModel()
    }

}
