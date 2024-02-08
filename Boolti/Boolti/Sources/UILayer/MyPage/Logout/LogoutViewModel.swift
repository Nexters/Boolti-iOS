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
            .subscribe(with: self) { owner, _ in
                // VC에게 알리기!..
            }
            .disposed(by: self.disposeBag)
    }

    private func logoutAccount() -> Single<Void> {
        self.logoutRepository.logout()
    }
}
