//
//  ConcertListDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation
import UIKit

final class ConcertListDIContainer {

    private let concertAPIService: ConcertAPIService

    init(concertAPIService: ConcertAPIService) {
        self.concertAPIService = concertAPIService
    }
    
    func createConcertListViewController() -> UIViewController {
        let viewModel = createConcertListViewModel()
        
        let concertDetailViewControllerFactory: () -> ConcertDetailViewController = {
            let DIContainer = self.createConcertDetailDIContainer()

            let viewController = DIContainer.createConcertDetailViewController()
            return viewController
        }

        let viewController = ConcertListViewController(
            viewModel: viewModel,
            concertDetailViewControllerFactory: concertDetailViewControllerFactory
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    private func createConcertListViewModel() -> ConcertListViewModel {
        return ConcertListViewModel()
    }
    
    private func createConcertDetailDIContainer() -> ConcertDetailDIContainer {
        return ConcertDetailDIContainer(concertAPIService: self.concertAPIService)
    }

}
