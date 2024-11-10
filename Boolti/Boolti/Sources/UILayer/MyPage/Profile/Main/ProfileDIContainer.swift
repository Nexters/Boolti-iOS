//
//  ProfileDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

final class ProfileDIContainer {

    private let repository: RepositoryType

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func createMyProfileViewController() -> ProfileViewController {
        let authRepository = self.repository as? AuthRepository ?? AuthRepository(networkService: NetworkProvider())

        let editProfileViewControllerFactory = {
            let DIContainer = EditProfileDIContainer(
                authRepository: authRepository
            )
            let viewController = DIContainer.createEditProfileViewController()
            
            return viewController
        }
        
        let linkListViewControllerFactory: ([LinkEntity]) -> LinkListViewController = { linkList in
            let DIContainer = LinkListDIContainer()
            let viewController = DIContainer.createLinkListViewController(linkList: linkList)
            
            return viewController
        }

        let viewModel = ProfileViewModel(repository: self.repository)
        let viewController = ProfileViewController(viewModel: viewModel,
                                                   editProfileViewControllerFactory: editProfileViewControllerFactory,
                                                   linkListControllerFactory: linkListViewControllerFactory)

        return viewController
    }

    func createProfileViewController(userCode: String) -> ProfileViewController {
        let viewModel = ProfileViewModel(repository: self.repository, userCode: userCode)
        
        let linkListViewControllerFactory: ([LinkEntity]) -> LinkListViewController = { linkList in
            let DIContainer = LinkListDIContainer()
            let viewController = DIContainer.createLinkListViewController(linkList: linkList)
            
            return viewController
        }

        let viewController = ProfileViewController(viewModel: viewModel,
                                                   linkListControllerFactory: linkListViewControllerFactory)

        return viewController
    }
}
