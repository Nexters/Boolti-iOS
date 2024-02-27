//
//  PosterExpandDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/24/24.
//

final class PosterExpandDIContainer {
    
    func createPosterExpandViewController(posters: [ConcertDetailEntity.Poster]) -> PosterExpandViewController {
        let viewModel = createPosterExpandViewModel(posters: posters)

        let viewController = PosterExpandViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createPosterExpandViewModel(posters: [ConcertDetailEntity.Poster]) -> PosterExpandViewModel {
        return PosterExpandViewModel(posters: posters)
    }

}
