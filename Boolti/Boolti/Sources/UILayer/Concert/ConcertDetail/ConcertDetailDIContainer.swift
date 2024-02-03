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
    
    func createConcertDetailViewController() -> UIViewController {
        let viewModel = createConcertDetailViewModel()

        let viewController = ConcertDetailViewController(
            viewModel: viewModel
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    private func createConcertDetailViewModel() -> ConcertDetailViewModel {
        return ConcertDetailViewModel()
    }

}
