//
//  GiftCompletionDIContainer.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import UIKit

final class GiftCompletionDIContainer {
    
    private let reservationRepository: ReservationRepositoryType
    
    init(reservationRepository: ReservationRepositoryType) {
        self.reservationRepository = reservationRepository
    }
    
    func createGiftCompletionViewController(giftID: Int) -> GiftCompletionViewController {
        let viewModel = createGiftCompletionViewModel(giftID: giftID)
        
        let viewController = GiftCompletionViewController(
            viewModel: viewModel
        )
        
        return viewController
    }
    
    private func createGiftCompletionViewModel(giftID: Int) -> GiftCompletionViewModel {
        return GiftCompletionViewModel(giftID: giftID,
                                       reservationRepository: reservationRepository)
    }
    
}
