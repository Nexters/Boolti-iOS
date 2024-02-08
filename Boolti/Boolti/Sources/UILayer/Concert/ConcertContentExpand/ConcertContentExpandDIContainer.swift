//
//  ConcertContentExpandDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/6/24.
//

final class ConcertContentExpandDIContainer {
    
    func createConcertContentExpandViewController(content: String) -> ConcertContentExpandViewController {
        let viewModel = createConcertContentExpandViewModel(content: content)

        let viewController = ConcertContentExpandViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createConcertContentExpandViewModel(content: String) -> ConcertContentExpandViewModel {
        return ConcertContentExpandViewModel(content: content)
    }

}
