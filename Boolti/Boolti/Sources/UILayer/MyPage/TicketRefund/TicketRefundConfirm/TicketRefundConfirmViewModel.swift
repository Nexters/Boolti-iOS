//
//  TicketRefundConfirmViewModel.swift
//  Boolti
//
//  Created by Miro on 2/14/24.
//

import Foundation

final class TicketRefundConfirmViewModel {
    
    private let reasonText: String
    private let reservationID: String
    let refundAccountInformation: RefundAccountInformation
    
    private let ticketReservationRepository: TicketReservationsRepositoryType

    init(reasonText: String, reservationID: String, refundAccountInformation: RefundAccountInformation, ticketReservationRepository: TicketReservationsRepositoryType) {
        self.reasonText = reasonText
        self.reservationID = reservationID
        self.refundAccountInformation = refundAccountInformation
        self.ticketReservationRepository = ticketReservationRepository
    }

}
