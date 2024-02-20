//
//  ResignViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/15/24.
//

import Foundation

import RxSwift
import RxRelay

final class ResignViewModel {

    struct Input {
        let didResignConfirmButtonTap = PublishRelay<Void>()
    }

    struct Output {
        let didResignAccount = PublishRelay<Void>()
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
        self.input.didResignConfirmButtonTap
            .flatMap { self.resignAccount() }
            .subscribe(with: self) { owner, _ in
                owner.output.didResignAccount.accept(())
            }
            .disposed(by: self.disposeBag)
    }

    private func resignAccount() -> Single<Void> {
        return self.authRepository.logout()
    }
}
