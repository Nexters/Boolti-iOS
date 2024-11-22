//
//  TicketDetailViewModel.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import Foundation

import RxSwift
import RxRelay
import RxMoya

final class TicketDetailViewModel {

    struct Input {
        var viewWillAppearEvent = PublishSubject<Void>()
        var refreshControlEvent = PublishSubject<Void>()
        var didCancelGiftButtonTappedEvent = PublishSubject<Void>()
    }

    struct Output {
        let isLoading = PublishRelay<Bool>()
        let fetchedTicketDetail = BehaviorRelay<TicketDetailItemEntity?>(value: nil)
        let didCanceledGift = PublishRelay<Void>()
    }

    let input: Input
    let output: Output

    private let networkService: NetworkProviderType
    private let disposeBag = DisposeBag()

    private let ticketID: String

    init(ticketID: String, networkService: NetworkProviderType) {
        self.networkService = networkService
        self.ticketID = ticketID

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .take(1)
            .do(onNext: { _ in
                self.output.isLoading.accept(true)
            })
            .flatMap { self.fetchTicketDetailItem() }
            .subscribe(with: self) { owner, ticketDetailItem in
                owner.output.fetchedTicketDetail.accept(ticketDetailItem)
                owner.output.isLoading.accept(false)
            }
            .disposed(by: self.disposeBag)

        self.input.refreshControlEvent
            .flatMap { self.fetchTicketDetailItem() }
            .subscribe(with: self) { owner, ticketDetailItem in
                owner.output.fetchedTicketDetail.accept(ticketDetailItem)
                owner.output.isLoading.accept(false)
            }
            .disposed(by: self.disposeBag)

        self.input.didCancelGiftButtonTappedEvent
            .flatMap { self.cancelReceivedGift() }
            .bind(to: self.output.didCanceledGift)
            .disposed(by: self.disposeBag)
    }

    private func fetchTicketDetailItem() -> Single<TicketDetailItemEntity> {
        // MARK: 의존성 networkService로 바꿔주기!..
        let ticketDetailRequestDTO = TicketDetailRequestDTO(reservationID: self.ticketID)
        let ticketDetailAPI = TicketAPI.detail(requestDTO: ticketDetailRequestDTO)

        return networkService.request(ticketDetailAPI)
            .map(TicketDetailResponseDTO.self)
            .map { $0.convertToTicketDetailItemEntity() }
    }

    private func cancelReceivedGift() -> Single<Void> {
        let giftUUID = self.output.fetchedTicketDetail.value?.giftUUID
        let giftCancelAPI = TicketAPI.cancelGift(giftUUID: giftUUID ?? "")

        return networkService.request(giftCancelAPI)
            .map { _ in return Void() }
    }
}
