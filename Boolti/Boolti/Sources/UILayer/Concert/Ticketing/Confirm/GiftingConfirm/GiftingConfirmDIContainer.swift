//
//  GiftingConfirmDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/21/24.
//

import UIKit

final class GiftingConfirmDIContainer {

    private let giftingRepository: GiftingRepository

    init(giftingRepository: GiftingRepository) {
        self.giftingRepository = giftingRepository
    }

    func createGiftingConfirmViewController(giftingEntity: GiftingEntity) -> GiftingConfirmViewController {
        let viewModel = createGiftingConfirmViewModel(giftingEntity: giftingEntity)

        let viewController = GiftingConfirmViewController(viewModel: viewModel)
        
        return viewController
    }

    private func createGiftingConfirmViewModel(giftingEntity: GiftingEntity) -> GiftingConfirmViewModel {
        return GiftingConfirmViewModel(giftingRepository: self.giftingRepository, 
                                       giftingEntity: giftingEntity)
    }

}
