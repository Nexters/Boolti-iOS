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

    struct Input {
        var viewDidAppearEvent = PublishSubject<Void>()
        var didLoginButtonTapEvent = PublishSubject<Void>()
        var didSettingViewTapEvent = PublishSubject<Void>()
        var didTicketingReservationsViewTapEvent = PublishSubject<Void>()
        var didQRScannerListViewTapEvent = PublishSubject<Void>()
        var didProfileButtonTapEvent = PublishSubject<Void>()
    }

    struct Output {
        let isAccessTokenLoaded = BehaviorRelay<Bool>(value: false)
        let navigation = PublishRelay<MyPageDestination>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewDidAppearEvent
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
        
        self.input.didSettingViewTapEvent
            .subscribe(with: self) { owner, _ in
                guard owner.output.isAccessTokenLoaded.value else {
                    return owner.output.navigation.accept(.login)
                }
                owner.output.navigation.accept(.setting)
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
        
        self.input.didQRScannerListViewTapEvent
            .subscribe(with: self) { owner, _ in
                guard owner.output.isAccessTokenLoaded.value else {
                    return owner.output.navigation.accept(.login)
                }
                owner.output.navigation.accept(.qrScannerList)
            }
            .disposed(by: self.disposeBag)
        
        self.input.didProfileButtonTapEvent
            .subscribe(with: self) { owner, _ in
                guard owner.output.isAccessTokenLoaded.value else {
                    return owner.output.navigation.accept(.login)
                }
                owner.output.navigation.accept(.profile)
            }
            .disposed(by: self.disposeBag)
    }

    private func isAccessTokenAvailable() -> Bool {
        let token = self.authRepository.fetchTokens()
        let accessToken = token.0
        return (!accessToken.isEmpty)
    }
}
