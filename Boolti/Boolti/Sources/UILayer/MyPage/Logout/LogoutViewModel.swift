//
//  LogoutViewModel.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

import RxSwift
import RxRelay

final class LogoutViewModel {

    struct Input {
        let didLogoutConfirmButtonTap = PublishRelay<Void>()
    }

    struct Output {
        let didLogoutAccount = PublishRelay<Void>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    private let logoutRepository: LogoutRepositoryType

    init(logoutRepository: LogoutRepositoryType) {
        self.logoutRepository = logoutRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.didLogoutConfirmButtonTap
            .flatMap { self.logoutAccount() }
            .do(onNext: { _ in
                // 회원 토큰 초기화하기!
                UserDefaults.accessToken = ""
                UserDefaults.refreshToken = ""
            })
            .subscribe(with: self) { owner, _ in
                owner.output.didLogoutAccount.accept(())
            }
            .disposed(by: self.disposeBag)
    }

    private func logoutAccount() -> Single<Void> {
        self.logoutRepository.logout()
    }
}
