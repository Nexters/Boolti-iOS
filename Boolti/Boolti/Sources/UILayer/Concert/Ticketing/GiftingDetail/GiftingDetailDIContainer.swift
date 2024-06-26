//
//  GiftingDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 6/23/24.
//

final class GiftingDetailDIContainer {

    func createGiftingDetailViewController() -> GiftingDetailViewController {
        let viewModel = createGiftingDetailViewModel()
        
        let businessInfoViewControllerFactory = {
            let DIContainer = BusinessInfoDIContainer()
            let viewController = DIContainer.createBusinessInfoViewController()

            return viewController
        }

        let viewController = GiftingDetailViewController(viewModel: viewModel, businessInfoViewControllerFactory: businessInfoViewControllerFactory)
        
        return viewController
    }

    private func createGiftingDetailViewModel() -> GiftingDetailViewModel {
        return GiftingDetailViewModel()
    }

}
