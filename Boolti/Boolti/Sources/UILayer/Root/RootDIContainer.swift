//
//  RootDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class RootDIContainer {

    let rootViewModel: RootViewModel

    init() {
        self.rootViewModel = RootViewModel()
    }

    func createRootViewController() -> RootViewController {
        let splashViewControllerFactory: () -> SplashViewController = {
            let DIContainer = self.createSplashDIContainer()
            return DIContainer.createSplashViewController()
        }

        let tabBarControllerFactory: () -> TabBarController = {
            let DIContainer = self.createHomeDIContainer()
            return DIContainer.createTabBarController()
        }

        return RootViewController(
            viewModel: rootViewModel,
            splashViewControllerFactory: splashViewControllerFactory,
            tabBarControllerFactory: tabBarControllerFactory
        )
    }

    private func createSplashDIContainer() -> SplashDIContainer {
        return SplashDIContainer(rootDIContainer: self)
    }

    private func createHomeDIContainer() -> TabBarDIContainer {
        return TabBarDIContainer(rootDIContainer: self)
    }
}
