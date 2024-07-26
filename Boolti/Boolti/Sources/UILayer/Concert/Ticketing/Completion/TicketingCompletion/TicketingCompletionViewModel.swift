//
//  TicketingCompletionViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit

import RxSwift
import RxRelay

final class TicketingCompletionViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let reservationRepository: ReservationRepositoryType

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
         reservationRepository: ReservationRepositoryType) {
        self.reservationId = reservationId
        self.reservationRepository = reservationRepository

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

extension TicketingCompletionViewModel {

    private func fetchReservationDetail() -> Single<TicketReservationDetailEntity> {
        return self.reservationRepository.ticketReservationDetail(with: "\(self.reservationId)")
    }
}
