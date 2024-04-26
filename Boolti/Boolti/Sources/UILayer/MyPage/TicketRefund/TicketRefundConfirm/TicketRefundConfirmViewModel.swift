//
//  TicketRefundConfirmViewModel.swift
//  Boolti
//
//  Created by Miro on 2/14/24.
//

import Foundation


import RxSwift
import RxRelay

final class TicketRefundConfirmViewModel {

    struct Input {
        let didRequestFundButtonTapEvent = PublishRelay<Void>()
    }

    struct Output {
        let didRequestFundCompleted = PublishRelay<Void>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    private let reasonText: String
    private let reservationID: String
    let refundAccountInformation: RefundAccountInformation
    
    private let ticketReservationRepository: TicketReservationsRepositoryType

    init(reasonText: String, reservationID: String, refundAccountInformation: RefundAccountInformation, ticketReservationRepository: TicketReservationsRepositoryType) {
        self.reasonText = reasonText
        self.reservationID = reservationID
        self.refundAccountInformation = refundAccountInformation
        self.ticketReservationRepository = ticketReservationRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.didRequestFundButtonTapEvent
            .flatMap { self.requestReservationRefund() }
            .subscribe(with: self) { owner, _ in
                owner.output.didRequestFundCompleted.accept(())
            }
            .disposed(by: self.disposeBag)
    }

    private func requestReservationRefund() -> Single<Void>{
        let requestDTO = TicketRefundRequestDTO(reservationId: Int(self.reservationID)!, cancelReason: self.reasonText)
        return self.ticketReservationRepository.requestRefund(with: requestDTO)
    }
}
