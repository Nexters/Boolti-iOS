//
//  TermsAgreementViewModel.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import Foundation
import RxSwift

class TermsAgreementViewModel {

    struct Input {
        var agreementButtonDidTapEvent = PublishSubject<Void>()
    }

    let input: Input
    private let disposeBag = DisposeBag()

    // 현재는 의존성 없음
    init() {
        self.input = Input()
        self.bindInputs()
    }

    private func bindInputs() {
        // 현재는 ViewModel에서 처리할 일이 없음!..
//        self.input.agreementButtonDidTapEvent
//            .subscribe(with: self) { owner, _ in
//                <#code#>
//            }
//            .disposed(by: self.disposeBag)
    }


}
