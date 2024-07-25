//
//  GiftReservationDetailViewModel.swift
//  Boolti
//
//  Created by Miro on 7/22/24.
//

import Foundation

import RxSwift
import RxRelay
/*
‼️‼️‼️
TODO: TicketReservationDetailEntity을 ReservationDetailEntityProtocol로 변경해서
 GiftReservationDetail과 TicketReservationDetail을 통합하기..
 현재는 따로 구현!!...
 */

final class GiftReservationDetailViewModel {

    struct Input {
        let viewWillAppearEvent = PublishRelay<Void>()
    }

    struct Output {
        let tickerReservationDetail = BehaviorRelay<GiftReservationDetailEntity?>(value: nil)
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    private let giftReservationsRepository: TicketReservationsRepositoryType
    let giftID: String

    init(giftID: String, giftReservationsRepository: TicketReservationsRepositoryType) {
        self.giftID = giftID
        self.giftReservationsRepository = giftReservationsRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .flatMap { self.fetchGiftReservationDetail() }
            .subscribe(with: self, onNext: { owner, ticketReservationDetail in
                owner.output.tickerReservationDetail.accept(ticketReservationDetail)
            })
            .disposed(by: self.disposeBag)
    }

    private func fetchGiftReservationDetail() -> Single<GiftReservationDetailEntity> {
        return self.giftReservationsRepository.giftReservationDetail(with: self.giftID)
    }
}
