//
//  TicketListDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

final class TicketListDIContainer {

    typealias TicketID = String
    typealias QRCodeImage = UIImage
    typealias TicketName = String

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createTicketListViewController() -> UIViewController {
        let viewModel = createTicketListViewModel()

        let loginViewControllerFactory: () -> LoginViewController = {
            let DIContainer = self.createLoginViewDIContainer()

            let viewController = DIContainer.createLoginViewController()
            return viewController
        }

        let ticketDetailViewControllerFactory: (TicketID) -> TicketDetailViewController = { ticketID in
            let DIContainer = self.createTicketDetailDIContainer()

            let viewController = DIContainer.createTicketDetailController(ticketID: ticketID)
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
            authRepository: self.authRepository,
            oauthRepository: OAuthRepository(),
            pushNotificationRepository: PushNotificationRepository(networkService: self.authRepository.networkService)
        )
    }

    private func createTicketDetailDIContainer() -> TicketDetailDIContainer {
        return TicketDetailDIContainer(authRepository: self.authRepository)
    }

    private func createTicketListViewModel() -> TicketListViewModel {
        return TicketListViewModel(authRepository: self.authRepository)
    }

}
