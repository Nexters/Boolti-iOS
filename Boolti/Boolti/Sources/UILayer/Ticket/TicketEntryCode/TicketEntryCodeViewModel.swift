//
//  TicketEntryCodeViewModel.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import Foundation

import RxSwift
import RxMoya
import RxRelay

class TicketEntryCodeViewModel {

    struct Input {
        var didCheckButtonTapEvent = PublishSubject<Void>()
    }

    struct Output {
        let isValidEntryCode = PublishRelay<Bool>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    private let networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.didCheckButtonTapEvent
            .flatMap { self.validateEntryCode() }
            .subscribe(with: self) { owner, isValid in
                print("🔥🔥🔥🔥🔥")
                owner.output.isValidEntryCode.accept(isValid)
            }
            .disposed(by: self.disposeBag)
    }

    private func validateEntryCode() -> Single<Bool> {
        return Single.just(false)
    }
}
