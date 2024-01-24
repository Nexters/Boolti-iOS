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

    // VC에서 일어나는 것
    struct Input {
        var viewDidAppearEvent = PublishSubject<Void>()
        var loginButtonTapEvent = PublishSubject<Void>()
    }

    // Input에 의해서 생기는 ViewModel의 Output
    struct Output {
        let navigation = PublishRelay<TicketViewDestination>()
        let isAccessTokenLoaded = PublishRelay<Bool>()
    }

    let input: Input
    let output: Output

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
        // 화면이 뜨면, 현재 accessToken이 있는 지 확인한다.
        self.input.viewDidAppearEvent
            .subscribe(with: self) { owner, _ in
                self.loadAccessToken()
            }
            .disposed(by: self.disposeBag)
    }

    private func bindLoginButtonTapEvent() {
        // 로그인 버튼을 누르면 로그인 화면으로 넘어가기
        self.input.loginButtonTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                self.output.navigation.accept(.login)
            })
            .disposed(by: self.disposeBag)
    }

    private func loadAccessToken() {
        // accessToken이 있으면 output으로 넘기기!..
        let token = authAPIService.fetchTokens()
        self.output.isAccessTokenLoaded.accept(!token.accessToken.isEmpty)
    }
}
