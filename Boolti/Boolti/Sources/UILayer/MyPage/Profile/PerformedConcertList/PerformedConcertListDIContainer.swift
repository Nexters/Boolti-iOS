//
//  PerformedConcertListDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/12/24.
//

import UIKit

final class PerformedConcertListDIContainer {
    
    private let repository: RepositoryType

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func createPerformedConcertListViewController(performedConcertList: [ConcertEntity]) -> PerformedConcertListViewController {
        
        let concertDetailViewControllerFactory: (Int) -> ConcertDetailViewController = { concertId in
            let DIContainer = ConcertDetailDIContainer(authRepository: AuthRepository(networkService: self.repository.networkService),
                                                               concertRepository: ConcertRepository(networkService: self.repository.networkService))
            let viewController = DIContainer.createConcertDetailViewController(concertId: concertId)
            
            return viewController
        }

        let viewModel = PerformedConcertListViewModel(concertList: performedConcertList)
        let viewController = PerformedConcertListViewController(viewModel: viewModel,
                                                                concertDetailViewControllerFactory: concertDetailViewControllerFactory)

        return viewController
    }

}
