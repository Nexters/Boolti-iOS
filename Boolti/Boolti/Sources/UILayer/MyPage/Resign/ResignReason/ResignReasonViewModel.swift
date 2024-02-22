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
        let didResignConfirmButtonTap = PublishRelay<Void>()
        let reason = BehaviorRelay<String>(value: "")
    }

    struct Output {
        let didResignAccount = PublishRelay<Void>()
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
                
                // kakao인지 apple 로그인인지 분기처리 필요
                owner.oauthRepository.resign(provider: .kakao)
                    .subscribe(onCompleted: {
                        owner.resign()
                    })
                    .disposed(by: owner.disposeBag)
                }
            .disposed(by: self.disposeBag)
    }
    
    private func resign() {
        self.authRepository.resign(reason: self.input.reason.value)
            .subscribe(with: self) { owner, _ in
                owner.output.didResignAccount.accept(())
            }
            .disposed(by: self.disposeBag)
    }
}
