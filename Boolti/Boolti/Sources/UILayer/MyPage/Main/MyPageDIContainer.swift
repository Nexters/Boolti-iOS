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

        let QrScanViewControllerFactory = {
            let DIContainer = self.createqrScanDIContainer()
            let viewController = DIContainer.createQrScanViewController()

            return viewController
        }

        let viewController = MyPageViewController(
            viewModel: self.createMyPageViewModel(),
            logoutViewControllerViewControllerFactory: logoutViewControllerFactory,
            ticketReservationsViewControllerFactory: ticketReservationsViewControllerFactory,
            qrScanViewControllerFactory: QrScanViewControllerFactory
        )

        let navigationController = UINavigationController(rootViewController: viewController)

        return navigationController
    }

    private func createLogoutDIContainer() -> LogoutDIContainer {
        return LogoutDIContainer(authRepository: self.authRepository)
    }

    private func createTicketReservationsDIContainer() -> TicketReservationsDIContainer {
        return TicketReservationsDIContainer(networkService: self.authRepository.networkService)
    }

    private func createqrScanDIContainer() -> QrScanDIContainer {
        return QrScanDIContainer()
    }

    private func createMyPageViewModel() -> MyPageViewModel {
        return MyPageViewModel(authRepository: self.authRepository, networkService: self.authRepository.networkService)
    }
}
