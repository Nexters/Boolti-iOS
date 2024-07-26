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

    private let reasonText: String?
    private let refundID: String

    let isGift: Bool
    let refundAccountInformation: RefundAccountInformation
    
    private let reservationRepository: ReservationRepositoryType

    init(reasonText: String?, reservationID: String, refundAccountInformation: RefundAccountInformation, isGift: Bool, reservationRepository: ReservationRepositoryType) {
        self.reasonText = reasonText
        self.refundID = reservationID
        self.refundAccountInformation = refundAccountInformation
        self.isGift = isGift
        self.reservationRepository = reservationRepository

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
        // TODO: 이거 또 정리하기... RefundID가 혼동되고 있음
        if isGift {
            print(self.refundID)
            let requestDTO = GiftRefundRequestDTO(giftUuid: self.refundID)
            return self.reservationRepository.requestGiftRefund(with: requestDTO)
        } else {
            let requestDTO = TicketRefundRequestDTO(reservationId: Int(self.refundID)!, cancelReason: self.reasonText ?? "")
            return self.reservationRepository.requestRefund(with: requestDTO)
        }

    }
}
