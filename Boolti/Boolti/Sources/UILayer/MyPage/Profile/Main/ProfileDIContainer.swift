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
        let concertRepository = self.repository
        let authRepository = AuthRepository(networkService: self.repository.networkService)

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
        
        let performedConcertListControllerFactory: ([ConcertEntity]) -> PerformedConcertListViewController = { concertList in
            let DIContainer = PerformedConcertListDIContainer(repository: concertRepository)
            let viewController = DIContainer.createPerformedConcertListViewController(performedConcertList: concertList)
            
            return viewController
        }
        
        let concertDetailViewControllerFactory: (Int) -> ConcertDetailViewController = { concertId in
            let DIContainer = ConcertDetailDIContainer(authRepository: authRepository,
                                                       concertRepository: concertRepository as? ConcertRepository ?? ConcertRepository(networkService: self.repository.networkService))
            let viewController = DIContainer.createConcertDetailViewController(concertId: concertId)
            
            return viewController
        }

        let viewModel = ProfileViewModel(repository: authRepository)
        let viewController = ProfileViewController(viewModel: viewModel, editProfileViewControllerFactory: editProfileViewControllerFactory, linkListControllerFactory: linkListViewControllerFactory, performedConcertListControllerFactory: performedConcertListControllerFactory, concertDetailViewControllerFactory: concertDetailViewControllerFactory)

        return viewController
    }

    func createProfileViewController(userCode: String) -> ProfileViewController {
        let viewModel = ProfileViewModel(repository: self.repository, userCode: userCode)
        
        let linkListViewControllerFactory: ([LinkEntity]) -> LinkListViewController = { linkList in
            let DIContainer = LinkListDIContainer()
            let viewController = DIContainer.createLinkListViewController(linkList: linkList)
            
            return viewController
        }
        
        let performedConcertListControllerFactory: ([ConcertEntity]) -> PerformedConcertListViewController = { concertList in
            let DIContainer = PerformedConcertListDIContainer(repository: self.repository)
            let viewController = DIContainer.createPerformedConcertListViewController(performedConcertList: concertList)
            
            return viewController
        }
        
        let concertDetailViewControllerFactory: (Int) -> ConcertDetailViewController = { concertId in
            let DIContainer = ConcertDetailDIContainer(authRepository: AuthRepository(networkService: self.repository.networkService),
                                                               concertRepository: ConcertRepository(networkService: self.repository.networkService))
            let viewController = DIContainer.createConcertDetailViewController(concertId: concertId)
            
            return viewController
        }

        let viewController = ProfileViewController(viewModel: viewModel,
                                                   linkListControllerFactory: linkListViewControllerFactory, performedConcertListControllerFactory: performedConcertListControllerFactory,
                                                   concertDetailViewControllerFactory: concertDetailViewControllerFactory)

        return viewController
    }
}
