//
//  RootDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class RootDIContainer {

    let rootViewModel: RootViewModel
    private let networkProvider: NetworkProvider

    init() {
        self.rootViewModel = RootViewModel()
        self.networkProvider = NetworkProvider()
    }

    func createRootViewController() -> RootViewController {
        let splashViewControllerFactory: () -> SplashViewController = {
            let DIContainer = self.createSplashDIContainer()
            return DIContainer.createSplashViewController()
        }

        let homeTabBarControllerFactory: (Token) -> HomeTabBarController = { token in
            let DIContainer = self.createHomeTabBarDIContainer(token: token)
            return DIContainer.createHomeTabBarController()
        }

        return RootViewController(
            viewModel: rootViewModel,
            splashViewControllerFactory: splashViewControllerFactory,
            hometabBarControllerFactory: homeTabBarControllerFactory
        )
    }

    private func createSplashDIContainer() -> SplashDIContainer {
        return SplashDIContainer(rootDIContainer: self, networkProvider: networkProvider)
    }

    private func createHomeTabBarDIContainer(token: Token) -> HomeTabBarDIContainer {
        return HomeTabBarDIContainer(token: token, rootDIContainer: self)
    }
}
