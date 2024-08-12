//
//  TicketingCompletionDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit

final class TicketingCompletionDIContainer {
    
    private let reservationRepository: ReservationRepositoryType
    
    init(reservationRepository: ReservationRepositoryType) {
        self.reservationRepository = reservationRepository
    }

    func createTicketingCompletionViewController(reservationId: Int) -> TicketingCompletionViewController {
        let viewModel = createTicketingCompletionViewModel(reservationId: reservationId)
        
        let viewController = TicketingCompletionViewController(
            viewModel: viewModel
        )
        
        return viewController
    }

    private func createTicketingCompletionViewModel(reservationId: Int) -> TicketingCompletionViewModel {
        return TicketingCompletionViewModel(reservationId: reservationId,
                                            reservationRepository: reservationRepository)
    }

}
