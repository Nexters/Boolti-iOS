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
        
        let settingViewControllerFactory = {
            let DIContainer = SettingDIContainer(authRepository: self.authRepository)
            let viewController = DIContainer.createSettingViewController()
            
            return viewController
        }

        let viewController = MyPageViewController(
            viewModel: self.createMyPageViewModel(),
            loginViewControllerFactory: loginViewControllerFactory,
            ticketReservationsViewControllerFactory: ticketReservationsViewControllerFactory,
            qrScanViewControllerFactory: QRScannerListViewControllerFactory,
            settingViewControllerFactory: settingViewControllerFactory
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true

        return navigationController
    }
    
    private func createTicketReservationsDIContainer() -> TicketReservationsDIContainer {
        return TicketReservationsDIContainer(networkService: self.authRepository.networkService)
    }

    private func createQRScannerListDIContainer() -> QRScannerListDIContainer {
        return QRScannerListDIContainer(qrRepository: QRRepository(networkService: self.authRepository.networkService))
    }

    private func createLoginViewDIContainer() -> LoginViewDIContainer {
        return LoginViewDIContainer(
            authRepository: self.authRepository,
            oauthRepository: OAuthRepository(),
            pushNotificationRepository: PushNotificationRepository(networkService: self.authRepository.networkService)
        )
    }

    private func createMyPageViewModel() -> MyPageViewModel {
        return MyPageViewModel(authRepository: self.authRepository, networkService: self.authRepository.networkService)
    }
}
