//
//  HomeTabBarDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

final class HomeTabBarDIContainer {

    // TODO: 아래의 의존성은 다시 설정할 예정

    private let rootDIContainer: RootDIContainer

    init(rootDIContainer: RootDIContainer) {
        self.rootDIContainer = rootDIContainer
    }

    func createHomeTabBarController() -> HomeTabBarController {
        return HomeTabBarController(
        viewModel: createHomeTabBarViewModel(),
        viewControllerFactory: createViewController(of:)
        )
    }

    private func createHomeTabBarViewModel() -> HomeTabBarViewModel {
        return HomeTabBarViewModel()
    }


    private func createViewController(of tab: HomeTab) -> UIViewController {
        let viewController: UIViewController
        switch tab {
        case .concert:
            let dependencyContainer = createConcertDIContainer()
            viewController = dependencyContainer.createConcertViewController()
        case .ticket:
            let dependencyContainer = createTicketDIContainer()
            viewController = dependencyContainer.createTicketViewController()
        case .myPage:
            let dependencyContainer = createMyPageDIContainer()
            viewController = dependencyContainer.createMyPageViewController()
        }

        viewController.tabBarItem = tab.asTabBarItem()
        return viewController
    }

    private func createConcertDIContainer() -> ConcertDIContainer {
        return ConcertDIContainer()
    }

    private func createTicketDIContainer() -> TicketDIContainer {
        return TicketDIContainer()
    }

    private func createMyPageDIContainer() -> MyPageDIContainer {
        return MyPageDIContainer()
    }

}
