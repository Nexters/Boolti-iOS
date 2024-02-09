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
    }

    struct Output {
        let isAccessTokenLoaded = PublishRelay<Bool>()
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
    }

    private func isAccessTokenAvailable() -> Bool {
        let token = self.authRepository.fetchTokens()
        let accessToken = token.0
        return (!accessToken.isEmpty)
    }
}
