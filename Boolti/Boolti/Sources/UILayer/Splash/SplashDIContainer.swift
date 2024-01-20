//
//  SplashDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class SplashDIContainer {

    let rootDIContainer: RootDIContainer

    init(rootDIContainer: RootDIContainer) {
        self.rootDIContainer = rootDIContainer
    }

    func createSplashViewController() -> SplashViewController {
        let viewController = SplashViewController(viewModel: createSplashViewModel())
        return viewController
    }

    private func createSplashViewModel() -> SplashViewModel {
        // TODO: 네트워크 의존성 주입하는 방법임!! 나중에 지워야함!
        let viewModel = SplashViewModel(networkService: AuthService())

        return viewModel
    }
}
