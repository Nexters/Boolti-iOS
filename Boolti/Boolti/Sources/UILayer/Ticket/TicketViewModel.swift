//
//  TicketViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation
import RxSwift
import RxRelay

enum TicketViewDestination {
    case login
}

final class TicketViewModel {

    private let authAPIService: AuthAPIServiceType

    private let disposeBag = DisposeBag()

    struct Input {
        var viewDidAppearEvent = PublishSubject<Void>()
        var loginButtonTapEvent = PublishSubject<Void>()
    }

    struct Output {
        let navigation = PublishSubject<TicketViewDestination>()
        let isAccessTokenLoaded = PublishSubject<Bool>()
    }

    let input: Input
    let output: Output

    // TODO: 토큰 여부 확인 후 로그인 뷰로 이동
    init(authAPIService: AuthAPIServiceType) {
        self.authAPIService = authAPIService

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.bindViewDidAppearEvent()
        self.bindLoginButtonTapEvent()
    }

    private func bindViewDidAppearEvent() {
        self.input.viewDidAppearEvent
            .subscribe(with: self) { owner, _ in
                self.loadAccessToken()
            }
            .disposed(by: self.disposeBag)
    }

    private func bindLoginButtonTapEvent() {
        self.input.loginButtonTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                self.output.navigation.onNext(.login)
            })
            .disposed(by: self.disposeBag)
    }

    private func loadAccessToken() {
        let token = authAPIService.fetchTokens()
        guard token.accessToken != "" && token.refreshToken != "" else {
            self.output.isAccessTokenLoaded.onNext(false)
            return
        }
        // 만약 accessToken이 존재한다면? 그냥 화면 띄우기!..
        self.output.isAccessTokenLoaded.onNext(true)

    }
}
