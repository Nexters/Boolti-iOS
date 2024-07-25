//
//  TicketReservationsViewModel.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

import RxSwift
import RxRelay

final class TicketReservationsViewModel {

    struct Input {
        let viewWillAppearEvent = PublishRelay<Void>()
    }

    struct Output {
        let tickerReservations = BehaviorRelay<[TicketReservationItemEntity]?>(value: nil)
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()
    private let ticketReservationsRepository: TicketReservationsRepositoryType

    init(ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.ticketReservationsRepository = ticketReservationsRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .flatMap { self.fetchTicketReservations() }
            .subscribe(with: self) { owner, ticketReservations in
                owner.output.tickerReservations.accept(ticketReservations)
            }
            .disposed(by: self.disposeBag)
    }

    private func fetchTicketReservations() -> Single<[TicketReservationItemEntity]> {
        return self.ticketReservationsRepository.ticketReservations()
    }
}
