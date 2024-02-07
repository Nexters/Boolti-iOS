//
//  ConcertDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

final class ConcertDetailDIContainer {

    private let concertAPIService: ConcertAPIService

    init(concertAPIService: ConcertAPIService) {
        self.concertAPIService = concertAPIService
    }
    
    func createConcertDetailViewController() -> ConcertDetailViewController {
        let viewModel = createConcertDetailViewModel()
        
        let concertContentExpandViewControllerFactory: (String) -> ConcertContentExpandViewController = { content in
            let DIContainer = self.createConcertContentExpandDIContainer()

            let viewController = DIContainer.createConcertContentExpandViewController(content: content)
            return viewController
        }

        let viewController = ConcertDetailViewController(
            viewModel: viewModel, 
            concertContentExpandViewControllerFactory: concertContentExpandViewControllerFactory
        )

        return viewController
    }
    
    private func createConcertContentExpandDIContainer() -> ConcertContentExpandDIContainer {
        return ConcertContentExpandDIContainer()
    }
    
    private func createConcertDetailViewModel() -> ConcertDetailViewModel {
        return ConcertDetailViewModel(concertAPIService: self.concertAPIService)
    }

}
