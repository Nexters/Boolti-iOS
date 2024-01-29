//
//  ConcertDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation
import UIKit

final class ConcertDIContainer {

//    private let ticketAPIService: TicketAPIService
//
//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
//    }
    
    func createConcertViewController() -> UIViewController {
        let viewModel = createConcertViewModel()

        let viewController = ConcertViewController(
            viewModel: viewModel
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    private func createConcertViewModel() -> ConcertViewModel {
        return ConcertViewModel()
    }

}
