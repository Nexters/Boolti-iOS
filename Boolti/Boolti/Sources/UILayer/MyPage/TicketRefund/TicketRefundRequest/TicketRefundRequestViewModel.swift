//
//  TicketRefundRequestViewModel.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import Foundation

import RxSwift
import RxRelay

final class TicketRefundRequestViewModel {

    struct Input {
        let viewWillAppearEvent = PublishRelay<Void>()
        let isReversalPolicyChecked = BehaviorRelay<Bool>(value: false)
    }

    struct Output {
        let tickerReservationDetail = BehaviorRelay<TicketReservationDetailEntity?>(value: nil)
        let isReversalPolicyChecked = PublishRelay<Bool>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    let reservationID: String
    let reasonText: String?
    private let reservationRepository: ReservationRepositoryType

    init(reservationID: String, reasonText: String, reservationRepository: ReservationRepositoryType) {
        self.reservationID = reservationID
        self.reasonText = reasonText
        self.reservationRepository = reservationRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .flatMap { self.fetchReservationDetail() }
            .subscribe(with: self, onNext: { owner, ticketReservationDetail in
                owner.output.tickerReservationDetail.accept(ticketReservationDetail)
            })
            .disposed(by: self.disposeBag)

        self.input.isReversalPolicyChecked
            .subscribe(with: self) { owner, isChecked in
                owner.output.isReversalPolicyChecked.accept(isChecked)
            }
            .disposed(by: self.disposeBag)
    }

    private func fetchReservationDetail() -> Single<TicketReservationDetailEntity> {
        return self.reservationRepository.ticketReservationDetail(with: self.reservationID)
    }
}
