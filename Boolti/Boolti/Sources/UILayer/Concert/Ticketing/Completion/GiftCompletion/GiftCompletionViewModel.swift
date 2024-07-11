//
//  GiftCompletionViewModel.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import UIKit

import RxSwift
import RxRelay

final class GiftCompletionViewModel {

    // MARK: Properties

    private let disposeBag = DisposeBag()
    private let ticketReservationsRepository: TicketReservationsRepositoryType

    struct Input {
        let viewWillAppearEvent = PublishSubject<Void>()
    }

    struct Output {
        let reservationDetail = PublishRelay<TicketReservationDetailEntity>()
    }

    let input: Input
    let output: Output
    let reservationId: Int

    // MARK: Init

    init(reservationId: Int,
         ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.reservationId = reservationId
        self.ticketReservationsRepository = ticketReservationsRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .flatMap { self.fetchReservationDetail() }
            .subscribe(with: self, onNext: { owner, ticketReservationDetail in
                owner.output.reservationDetail.accept(ticketReservationDetail)
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension GiftCompletionViewModel {

    private func fetchReservationDetail() -> Single<TicketReservationDetailEntity> {
        return self.ticketReservationsRepository.ticketReservationDetail(with: "\(self.reservationId)")
    }
}
