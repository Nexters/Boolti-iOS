//
//  TermsAgreementViewModel.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import Foundation

import RxSwift
import RxRelay

final class TermsAgreementViewModel {

    struct Input {
        var didAgreementButtonTapEvent = PublishSubject<Void>()
    }

    struct Output {
        var didsignUpFinished = PublishRelay<Void>()
    }

    let input: Input
    let output: Output

    private let authAPIService: AuthAPIServiceType
    private let identityCode: String
    private let provider: OAuthProvider

    private let disposeBag = DisposeBag()

    init(identityCode: String, provider: OAuthProvider, authAPIService: AuthAPIServiceType) {
        self.identityCode = identityCode
        self.provider = provider
        self.authAPIService = authAPIService

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.didAgreementButtonTapEvent
            .subscribe(with: self) { owner, _ in
                owner.authAPIService.signUp(provider: owner.provider, identityToken: owner.identityCode)
                owner.output.didsignUpFinished.accept(())
            }
            .disposed(by: self.disposeBag)
    }
}
