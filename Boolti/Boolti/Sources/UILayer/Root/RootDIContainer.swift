//
//  RootDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class RootDIContainer {

    private let rootViewModel: RootViewModel
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

        let tabBarControllerFactory: () -> TabBarController = {
            let DIContainer = self.createTabBarDIContainer()
            return DIContainer.createTabBarController()
        }

        return RootViewController(
            viewModel: rootViewModel,
            splashViewControllerFactory: splashViewControllerFactory,
            tabBarControllerFactory: tabBarControllerFactory
        )
    }

    private func createSplashDIContainer() -> SplashDIContainer {
        return SplashDIContainer(rootDIContainer: self, networkProvider: networkProvider)
    }

    private func createTabBarDIContainer() -> TabBarDIContainer {
        return TabBarDIContainer(rootDIContainer: self)
    }
}
