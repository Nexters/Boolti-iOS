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

class TicketDetailViewModel {

    struct Input {
        var viewWillAppearEvent = PublishSubject<Void>()
    }

    struct Output {
        let isLoading = PublishRelay<Bool>()
        let fetchedTicketDetail = PublishRelay<TicketDetailItem>()
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
        self.bindViewDidAppearEvent()
    }

    private func bindViewDidAppearEvent() {
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
    }

    private func fetchTicketDetailItem() -> Single<TicketDetailItem> {
        // MARK: 의존성 networkService로 바꿔주기!..
        let ticketDetailAPI = TicketAPI.detail(ticketID: self.ticketID)

        return networkService.request(ticketDetailAPI)
            .map(TicketDetailResponseDTO.self)
            .map { $0.convertToTicketDetailItem() }
    }
}
