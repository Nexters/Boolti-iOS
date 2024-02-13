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
    }

    struct Output {
        let tickerReservationDetail = PublishRelay<TicketReservationDetailEntity>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()


    private let reservationID: String
    private let reasonText: String
    private let ticketReservationsRepository: TicketReservationsRepositoryType

    init(reservationID: String, reasonText: String, ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.reservationID = reservationID
        self.reasonText = reasonText
        self.ticketReservationsRepository = ticketReservationsRepository

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
    }

    private func fetchReservationDetail() -> Single<TicketReservationDetailEntity> {
        return self.ticketReservationsRepository.ticketReservationDetail(with: self.reservationID)
    }
}
