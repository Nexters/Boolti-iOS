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
        let giftReservationDetail = BehaviorSubject<GiftReservationDetailEntity?>(value: nil)
    }

    let input: Input
    let output: Output
    let giftID: Int

    // MARK: Init

    init(giftID: Int, ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.giftID = giftID
        self.ticketReservationsRepository = ticketReservationsRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .flatMap { self.fetchGiftReservationDetail() }
            .subscribe(with: self) { owner, entity in
                owner.output.giftReservationDetail.onNext(entity)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension GiftCompletionViewModel {

    private func fetchGiftReservationDetail() -> Single<GiftReservationDetailEntity> {
        return self.ticketReservationsRepository.giftReservationDetail(with: "\(self.giftID)")
    }
}
