//
//  PerformedConcertListDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/12/24.
//

import UIKit

final class PerformedConcertListDIContainer {

    func createPerformedConcertListViewController(performedConcertList: [PerformedConcertEntity]) -> PerformedConcertListViewController {
        let viewModel = PerformedConcertListViewModel(concertList: performedConcertList)
        let viewController = PerformedConcertListViewController(viewModel: viewModel)

        return viewController
    }

}
