//
//  RootDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class RootDIContainer {

    let rootViewModel: RootViewModel
    let networkProvider: NetworkProviderType

    init() {
        self.networkProvider = NetworkProvider()
        self.rootViewModel = RootViewModel(networkService: self.networkProvider)
    }

    func createRootViewController() -> RootViewController {
        let splashViewControllerFactory: () -> SplashViewController = {
            let DIContainer = self.createSplashDIContainer()
            return DIContainer.createSplashViewController()
        }

        let homeTabBarControllerFactory: () -> HomeTabBarController = {
            let DIContainer = self.createHomeTabBarDIContainer()
            return DIContainer.createHomeTabBarController()
        }

        return RootViewController(
            viewModel: self.rootViewModel,
            splashViewControllerFactory: splashViewControllerFactory,
            hometabBarControllerFactory: homeTabBarControllerFactory
        )
    }

    private func createSplashDIContainer() -> SplashDIContainer {
        return SplashDIContainer(rootDIContainer: self, networkProvider: networkProvider)
    }

    private func createHomeTabBarDIContainer() -> HomeTabBarDIContainer {
        return HomeTabBarDIContainer(rootDIContainer: self)
    }
}
