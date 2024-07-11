//
//  GiftCompletionDIContainer.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import UIKit

final class GiftCompletionDIContainer {

    private let ticketReservationsRepository: TicketReservationsRepositoryType

    init(ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.ticketReservationsRepository = ticketReservationsRepository
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
                                            ticketReservationsRepository: ticketReservationsRepository)
    }

}
