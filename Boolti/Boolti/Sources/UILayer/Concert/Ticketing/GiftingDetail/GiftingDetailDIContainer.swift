//
//  GiftingDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 6/23/24.
//

final class GiftingDetailDIContainer {

    func createGiftingDetailViewController() -> GiftingDetailViewController {
        let viewModel = createGiftingDetailViewModel()

        let viewController = GiftingDetailViewController(viewModel: viewModel)
        
        return viewController
    }

    private func createGiftingDetailViewModel() -> GiftingDetailViewModel {
        return GiftingDetailViewModel()
    }

}
