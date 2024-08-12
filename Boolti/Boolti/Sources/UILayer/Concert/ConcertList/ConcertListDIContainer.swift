//
//  ConcertListDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import UIKit

final class ConcertListDIContainer {

    typealias ConcertId = Int

    private let authRepository: AuthRepository
    private let concertRepository: ConcertRepository

    init(authRepository: AuthRepository,
         concertRepository: ConcertRepository) {
        self.authRepository = authRepository
        self.concertRepository = concertRepository
    }
    
    func createConcertListViewController() -> UIViewController {
        let viewModel = createConcertListViewModel()
        
        let concertDetailViewControllerFactory: (ConcertId) -> ConcertDetailViewController = { concertId in
            let DIContainer = self.createConcertDetailDIContainer()

            let viewController = DIContainer.createConcertDetailViewController(concertId: concertId)
            return viewController
        }
        
        let businessInfoViewControllerFactory = {
            let DIContainer = self.createBusinessInfoDIContainer()
            let viewController = DIContainer.createBusinessInfoViewController()

            return viewController
        }
        
        let loginViewControllerFactory: () -> LoginViewController = {
            let DIContainer = self.createLoginViewDIContainer()
            
            let viewController = DIContainer.createLoginViewController()
            return viewController
        }

        let viewController = ConcertListViewController(
            viewModel: viewModel,
            concertDetailViewControllerFactory: concertDetailViewControllerFactory,
            businessInfoViewControllerFactory: businessInfoViewControllerFactory,
            loginViewControllerFactory: loginViewControllerFactory
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    private func createConcertListViewModel() -> ConcertListViewModel {
        return ConcertListViewModel(concertRepository: self.concertRepository)
    }
    
    private func createConcertDetailDIContainer() -> ConcertDetailDIContainer {
        return ConcertDetailDIContainer(authRepository: self.authRepository, concertRepository: self.concertRepository)
    }

    private func createBusinessInfoDIContainer() -> BusinessInfoDIContainer {
        return BusinessInfoDIContainer()
    }
    
    private func createLoginViewDIContainer() -> LoginViewDIContainer {
        return LoginViewDIContainer(
            authRepository: self.authRepository,
            oauthRepository: OAuthRepository(),
            pushNotificationRepository: PushNotificationRepository(networkService: self.authRepository.networkService)
        )
    }
}
