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

        let loginViewControllerFactory: () -> LoginViewController = {
            let DIContainer = self.createLoginViewDIContainer()

            let viewController = DIContainer.createLoginViewController()
            return viewController
        }

        let viewController = TicketViewController(
            viewModel: viewModel,
            loginViewControllerFactory: loginViewControllerFactory
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    private func createLoginViewDIContainer() -> LoginViewDIContainer {
        return LoginViewDIContainer(
            authAPIService: self.authAPIService,
            socialLoginAPIService: SocialLoginAPIService()
        )
    }

    private func createTicketViewModel() -> TicketViewModel {
        return TicketViewModel(authAPIService: self.authAPIService)
    }
}
