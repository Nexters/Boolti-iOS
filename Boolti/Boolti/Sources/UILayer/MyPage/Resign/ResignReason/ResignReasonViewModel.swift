//
//  ResignReasonViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/22/24.
//

import Foundation

import RxSwift
import RxRelay

final class ResignReasonViewModel {
    
    // MARK: Properties
    
    private let authRepository: AuthRepositoryType
    private let oauthRepository: OAuthRepositoryType
    private let disposeBag = DisposeBag()

    struct Input {
        let didResignConfirmButtonTap = PublishSubject<Void>()
        let reason = BehaviorRelay<String>(value: "")
    }

    struct Output {
        let didResignAccount = PublishSubject<Void>()
    }

    let input: Input
    let output: Output

    init(authRepository: AuthRepositoryType,
         oauthRepository: OAuthRepositoryType) {
        self.authRepository = authRepository
        self.oauthRepository = oauthRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.didResignConfirmButtonTap
            .subscribe(with: self) { owner, _ in
                owner.oauthRepository.resign()
                    .subscribe(onNext: { appleIdAuthorizationCode in
                        owner.resign(appleIdAuthorizationCode: appleIdAuthorizationCode)
                    })
                    .disposed(by: owner.disposeBag)
                }
            .disposed(by: self.disposeBag)
    }
    
    private func resign(appleIdAuthorizationCode: String?) {
        self.authRepository.resign(reason: self.input.reason.value, appleIdAuthorizationCode: appleIdAuthorizationCode)
            .subscribe(with: self) { owner, _ in
                owner.output.didResignAccount.onNext(())
            }
            .disposed(by: self.disposeBag)
    }
}
