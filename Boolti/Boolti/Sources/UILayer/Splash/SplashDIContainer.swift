//
//  SplashDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class SplashDIContainer {

    private let rootDIContainer: RootDIContainer
    private let networkProvider: NetworkProvider

    init(rootDIContainer: RootDIContainer, networkProvider: NetworkProvider) {
        self.rootDIContainer = rootDIContainer
        self.networkProvider = networkProvider
    }

    func createSplashViewController() -> SplashViewController {
        let updatePopupViewControllerFactory: () -> UpdatePopupViewController = {
            let DIContainer = self.createUpdatePopupDIContainer()

            let viewController = DIContainer.createUpdatePopupViewController()
            return viewController
        }
        
        let viewController = SplashViewController(viewModel: createSplashViewModel(),
                                                  updatePopupViewControllerFactory: updatePopupViewControllerFactory)
        return viewController
    }
    
    private func createUpdatePopupDIContainer() -> UpdatePopupDIContainer {
        return UpdatePopupDIContainer()
    }

    private func createSplashViewModel() -> SplashViewModel {
        // TODO: 네트워크 의존성 주입하는 방법임!! 나중에 지워야함!
        let viewModel = SplashViewModel(authRepository: AuthRepository(networkService: self.networkProvider), delegate: self.rootDIContainer.rootViewModel)

        return viewModel
    }
}
