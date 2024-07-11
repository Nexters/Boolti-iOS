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

    func createGiftCompletionViewController(reservationId: Int) -> GiftCompletionViewController {
        let viewModel = createGiftCompletionViewModel(reservationId: reservationId)

        let viewController = GiftCompletionViewController(
            viewModel: viewModel
        )

        return viewController
    }

    private func createGiftCompletionViewModel(reservationId: Int) -> GiftCompletionViewModel {
        return GiftCompletionViewModel(reservationId: reservationId,
                                            ticketReservationsRepository: ticketReservationsRepository)
    }

}
