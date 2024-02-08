//
//  TicketViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

import RxSwift
import RxRelay
import Moya
import RxMoya

enum TicketListViewDestination {
    case login
    case detail(ticketID: String)
}

final class TicketListViewModel {

    private let authRepository: AuthRepositoryType
    private let disposeBag = DisposeBag()

    // VC에서 일어나는 것
    struct Input {
        var viewDidAppearEvent = PublishSubject<Void>()
        var didloginButtonTapEvent = PublishSubject<Void>()
        var shouldLoadTableViewEvent = PublishSubject<Void>()
    }

    // Input에 의해서 생기는 ViewModel의 Output
    struct Output {
        let navigation = PublishRelay<TicketListViewDestination>()
        let isLoading = PublishRelay<Bool>()
        let isAccessTokenLoaded = PublishRelay<Bool>()
        let isTicketsExist = PublishRelay<Bool>()
        let sectionModels: BehaviorRelay<[TicketItemEntity]> = BehaviorRelay(value: [])
    }

    private let isAccessTokenExist = PublishRelay<Bool>()

    let input: Input
    let output: Output

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
        
        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.bindViewDidAppearEvent()
        self.bindLoginButtonTapEvent()
        self.bindShouldLoadTableViewEvent()
    }

    private func bindViewDidAppearEvent() {
        self.input.viewDidAppearEvent
            .subscribe(with: self) { owner, _ in
                if owner.isAccessTokenAvailable() {
                    owner.output.isAccessTokenLoaded.accept(true)
                } else {
                    owner.output.isAccessTokenLoaded.accept(false)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func bindLoginButtonTapEvent() {
        self.input.didloginButtonTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                owner.output.navigation.accept(.login)
            })
            .disposed(by: self.disposeBag)
    }

    private func bindShouldLoadTableViewEvent() {
        self.input.shouldLoadTableViewEvent
            .do(onNext: { [weak self] _ in
                self?.output.isLoading.accept(true)
            })
            .flatMap { self.fetchTicketList() }
            .subscribe(with: self) { owner, ticketItems in
                owner.output.isLoading.accept(false)
                if ticketItems.isEmpty {
                    owner.output.isTicketsExist.accept(false)
                } else {
                    owner.output.sectionModels.accept(ticketItems)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func isAccessTokenAvailable() -> Bool {
        let token = authRepository.fetchTokens()
        let accessToken = token.0
        return (!accessToken.isEmpty)
    }

    private func fetchTicketList() -> Single<[TicketItemEntity]> {
        // MARK: 의존성 networkService로 바꿔주기!..
        let networkProvider = self.authRepository.networkService
        let ticketListAPI = TicketAPI.list
        return networkProvider.request(ticketListAPI)
            .map([TicketListItemResponseDTO].self)
            .map { $0.map { $0.convertToTicketItemEntity() }}
    }
}
