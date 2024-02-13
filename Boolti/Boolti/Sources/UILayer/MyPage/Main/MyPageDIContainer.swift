//
//  MyPageDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

final class MyPageDIContainer {

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createMyPageViewController() -> UIViewController {

        let loginViewControllerFactory: () -> LoginViewController = {
            let DIContainer = self.createLoginViewDIContainer()

            let viewController = DIContainer.createLoginViewController()
            return viewController
        }

        let logoutViewControllerFactory = {
            let DIContainer = self.createLogoutDIContainer()
            let viewController = DIContainer.createLogoutViewController()

            return viewController
        }

        let ticketReservationsViewControllerFactory = {
            let DIContainer = self.createTicketReservationsDIContainer()
            let viewController = DIContainer.createTicketReservationsViewController()

            return viewController
        }

        let QRScannerListViewControllerFactory = {
            let DIContainer = self.createQRScannerListDIContainer()
            let viewController = DIContainer.createQRScannerListViewController()

            return viewController
        }

        let viewController = MyPageViewController(
            viewModel: self.createMyPageViewModel(),
            loginViewControllerFactory: loginViewControllerFactory,
            logoutViewControllerFactory: logoutViewControllerFactory,
            ticketReservationsViewControllerFactory: ticketReservationsViewControllerFactory,
            qrScanViewControllerFactory: QRScannerListViewControllerFactory
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true

        return navigationController
    }

    private func createLogoutDIContainer() -> LogoutDIContainer {
        return LogoutDIContainer(authRepository: self.authRepository)
    }

    private func createTicketReservationsDIContainer() -> TicketReservationsDIContainer {
        return TicketReservationsDIContainer(networkService: self.authRepository.networkService)
    }

    private func createQRScannerListDIContainer() -> QRScannerListDIContainer {
        return QRScannerListDIContainer(qrRepository: QRRepository(networkService: self.authRepository.networkService))
    }

    private func createLoginViewDIContainer() -> LoginViewDIContainer {
        return LoginViewDIContainer(authRepository: self.authRepository, socialLoginAPIService: OAuthRepository())
    }

    private func createMyPageViewModel() -> MyPageViewModel {
        return MyPageViewModel(authRepository: self.authRepository, networkService: self.authRepository.networkService)
    }
}
