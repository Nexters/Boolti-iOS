//
//  MyPageDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class MyPageDIContainer {

    private let networkService: NetworkProviderType

    init(authRepository: AuthRepositoryType) {
        self.networkService = authRepository.networkService
    }

    func createMyPageViewController() -> MyPageViewController {
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

        return viewController
    }

    private func createLogoutDIContainer() -> LogoutDIContainer {
        return LogoutDIContainer(networkService: self.networkService)
    }

    private func createTicketReservationsDIContainer() -> TicketReservationsDIContainer {
        return TicketReservationsDIContainer(networkService: self.networkService)
    }

    private func createqrScanDIContainer() -> QrScanDIContainer {
        return QrScanDIContainer()
    }

    private func createMyPageViewModel() -> MyPageViewModel {
        return MyPageViewModel(networkService: self.networkService)
    }
}
