//
//  GiftRefundRequestViewModel.swift
//  Boolti
//
//  Created by Miro on 7/24/24.
//

import Foundation

import RxSwift
import RxRelay

final class GiftRefundRequestViewModel {

    struct Input {
        let viewWillAppearEvent = PublishRelay<Void>()
        let isReversalPolicyChecked = BehaviorRelay<Bool>(value: false)
    }

    struct Output {
        let giftReservationDetail = BehaviorRelay<GiftReservationDetailEntity?>(value: nil)
        let isReversalPolicyChecked = PublishRelay<Bool>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    let giftID: String

    private let reservationRepository: ReservationRepositoryType

    init(giftID: String, reservationRepository: ReservationRepositoryType) {
        self.giftID = giftID
        self.reservationRepository = reservationRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .flatMap { self.fetchGiftReservationDetail() }
            .subscribe(with: self, onNext: { owner, giftReservationDetail in
                owner.output.giftReservationDetail.accept(giftReservationDetail)
            })
            .disposed(by: self.disposeBag)

        self.input.isReversalPolicyChecked
            .subscribe(with: self) { owner, isChecked in
                owner.output.isReversalPolicyChecked.accept(isChecked)
            }
            .disposed(by: self.disposeBag)
    }

    private func fetchGiftReservationDetail() -> Single<GiftReservationDetailEntity> {
        return self.reservationRepository.giftReservationDetail(with: self.giftID)
    }
}
