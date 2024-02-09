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

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.didLogoutConfirmButtonTap
            .flatMap { self.logoutAccount() }
            .subscribe(with: self) { owner, _ in
                owner.output.didLogoutAccount.accept(())
            }
            .disposed(by: self.disposeBag)
    }

    private func logoutAccount() -> Single<Void> {
        return self.authRepository.logout()
    }
}
