//
//  ConcertDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import Foundation
import UIKit

final class ConcertDetailDIContainer {

//    private let concertAPIService: ConcertAPIService
//
//    init(concertAPIService: ConcertAPIService) {
//        self.concertAPIService = concertAPIService
//    }
    
    func createConcertDetailViewController() -> ConcertDetailViewController {
        let viewModel = createConcertDetailViewModel()

        let viewController = ConcertDetailViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createConcertDetailViewModel() -> ConcertDetailViewModel {
        return ConcertDetailViewModel()
    }

}
