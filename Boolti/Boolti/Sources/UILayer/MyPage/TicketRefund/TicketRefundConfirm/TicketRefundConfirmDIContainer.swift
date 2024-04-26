//
//  TicketRefundConfirmDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/14/24.
//

import Foundation

struct RefundAccountInformation {
    let refundMethod: String?
    let totalRefundAmount: String
}

final class TicketRefundConfirmDIContainer {

    private let ticketReservationRepository: TicketReservationsRepositoryType

    init(ticketReservationRepository: TicketReservationsRepositoryType) {
        self.ticketReservationRepository = ticketReservationRepository
    }

    func createTicketRefundConfirmViewController(reservationID: String, reasonText: String, refundAccoundInformation: RefundAccountInformation) -> TicketRefundConfirmViewController{
        return TicketRefundConfirmViewController(viewModel: self.createTicketRefundConfirmViewModel(reservationID: reservationID, reasonText: reasonText, refundAccountInfomration: refundAccoundInformation))

    }

    private func createTicketRefundConfirmViewModel(reservationID: String, reasonText: String, refundAccountInfomration: RefundAccountInformation) -> TicketRefundConfirmViewModel{
        return TicketRefundConfirmViewModel(reasonText: reasonText, reservationID: reservationID, refundAccountInformation: refundAccountInfomration, ticketReservationRepository: self.ticketReservationRepository)
    }

}
