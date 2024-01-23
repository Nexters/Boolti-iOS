//
//  TicketDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

final class TicketDIContainer {

    private let authAPIService: AuthAPIServiceType

    init(authAPIService: AuthAPIServiceType) {
        self.authAPIService = authAPIService
    }

    func createTicketViewController() -> UIViewController {
        let viewModel = createTicketViewModel()
        let viewController = TicketViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    private func createTicketViewModel() -> TicketViewModel {
        return TicketViewModel(authAPIService: self.authAPIService)
    }
}
