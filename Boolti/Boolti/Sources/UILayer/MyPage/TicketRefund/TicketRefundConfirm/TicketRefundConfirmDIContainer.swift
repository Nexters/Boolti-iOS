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

    private let reservationRepository: ReservationRepositoryType

    init(reservationRepository: ReservationRepositoryType) {
        self.reservationRepository = reservationRepository
    }

    func createTicketRefundConfirmViewController(reservationID: String, reasonText: String?, isGift: Bool, refundAccoundInformation: RefundAccountInformation) -> TicketRefundConfirmViewController{
        return TicketRefundConfirmViewController(viewModel: self.createTicketRefundConfirmViewModel(reservationID: reservationID, reasonText: reasonText, isGift: isGift, refundAccountInfomration: refundAccoundInformation))
    }

    private func createTicketRefundConfirmViewModel(reservationID: String, reasonText: String?, isGift: Bool, refundAccountInfomration: RefundAccountInformation) -> TicketRefundConfirmViewModel{
        return TicketRefundConfirmViewModel(reasonText: reasonText, reservationID: reservationID, refundAccountInformation: refundAccountInfomration, isGift: isGift, reservationRepository: self.reservationRepository)
    }

}
