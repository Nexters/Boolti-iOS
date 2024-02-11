//
//  MyPageViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

import RxSwift
import RxRelay

final class MyPageViewModel {

    private let authRepository: AuthRepositoryType
    private let networkService: NetworkProviderType

    struct Input {
        var viewWillAppearEvent = PublishSubject<Void>()
        var didLogoutButtonTapEvent = PublishSubject<Void>()
        var didLoginButtonTapEvent = PublishSubject<Void>()
        var didTicketingReservationsViewTapEvent = PublishSubject<Void>()
    }

    struct Output {
        let isAccessTokenLoaded = BehaviorRelay<Bool>(value: false)
        let navigation = PublishRelay<MyPageDestination>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    init(authRepository: AuthRepositoryType, networkService: NetworkProviderType) {
        self.networkService = networkService
        self.authRepository = authRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .subscribe(with: self) { owner, _ in
                if owner.isAccessTokenAvailable() {
                    owner.output.isAccessTokenLoaded.accept(true)
                } else {
                    owner.output.isAccessTokenLoaded.accept(false)
                }
            }
            .disposed(by: self.disposeBag)

        self.input.didLoginButtonTapEvent
            .subscribe(with: self) { owner, _ in
                owner.output.navigation.accept(.login)
            }
            .disposed(by: self.disposeBag)

        self.input.didLogoutButtonTapEvent
            .subscribe(with: self) { owner, _ in
                owner.output.navigation.accept(.logout)
            }
            .disposed(by: self.disposeBag)

        self.input.didTicketingReservationsViewTapEvent
            .subscribe(with: self) { owner, _ in
                guard owner.output.isAccessTokenLoaded.value else {
                    return owner.output.navigation.accept(.login)
                }
                owner.output.navigation.accept(.ticketReservations)
            }
            .disposed(by: self.disposeBag)
    }

    private func isAccessTokenAvailable() -> Bool {
        let token = self.authRepository.fetchTokens()
        let accessToken = token.0
        return (!accessToken.isEmpty)
    }
}
