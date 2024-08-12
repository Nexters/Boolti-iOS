//
//  TicketReservationDetailViewModel.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

import RxSwift
import RxRelay

final class TicketReservationDetailViewModel {

    struct Input {
        let viewWillAppearEvent = PublishRelay<Void>()
    }

    struct Output {
        let tickerReservationDetail = PublishRelay<TicketReservationDetailEntity>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    private let reservationRepository: ReservationRepositoryType
    let reservationID: String

    init(reservationID: String, reservationRepository: ReservationRepositoryType) {
        self.reservationID = reservationID
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
    }

    private func fetchReservationDetail() -> Single<TicketReservationDetailEntity> {
        return self.reservationRepository.ticketReservationDetail(with: self.reservationID)
    }
}
