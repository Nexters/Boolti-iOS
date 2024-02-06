//
//  TicketListDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

final class TicketListDIContainer {

    private let authAPIService: AuthAPIServiceType

    init(authAPIService: AuthAPIServiceType) {
        self.authAPIService = authAPIService
    }

    func createTicketListViewController() -> UIViewController {
        let viewModel = createTicketListViewModel()

        let loginViewControllerFactory: () -> LoginViewController = {
            let DIContainer = self.createLoginViewDIContainer()

            let viewController = DIContainer.createLoginViewController()
            return viewController
        }

        let ticketDetailViewControllerFactory: (TicketItem) -> TicketDetailViewController = { ticketItem in
            let DIContainer = self.createTicketDetailDIContainer()

            let viewController = DIContainer.createTicketDetailController(ticketItem: ticketItem)
            return viewController
        }

        let viewController = TicketListViewController(
            viewModel: viewModel,
            loginViewControllerFactory: loginViewControllerFactory,
            ticketDetailViewControllerFactory: ticketDetailViewControllerFactory
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    private func createLoginViewDIContainer() -> LoginViewDIContainer {
        return LoginViewDIContainer(
            authAPIService: self.authAPIService,
            socialLoginAPIService: OAuthAPIService()
        )
    }

    private func createTicketDetailDIContainer() -> TicketDetailDIContainer {
        return TicketDetailDIContainer(authAPIService: self.authAPIService)
    }

    private func createTicketListViewModel() -> TicketListViewModel {
        return TicketListViewModel(authAPIService: self.authAPIService)
    }

}
