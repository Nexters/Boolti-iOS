//
//  TicketingCompletionViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit
import RxSwift
import RxRelay

final class TicketingCompletionViewModel {
    
//    private let ticketAPIService: TicketAPIServiceType
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let didCopyButtonTap = PublishSubject<Void>()
    }

    struct Output {
        let ticketingData: BehaviorRelay<TicketingEntity>
    }

    let input: Input
    let output: Output

//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
    init(ticketingEntity: TicketingEntity) {
        self.input = Input()
        self.output = Output(ticketingData: BehaviorRelay<TicketingEntity>(value: ticketingEntity))
        
        self.bindInputs()
    }
}

// MARK: - Methods

extension TicketingCompletionViewModel {
    
    private func bindInputs() {
        self.input.didCopyButtonTap
            .bind(with: self) { owner, _ in
                UIPasteboard.general.string = "신한은행 1234-56-7890123 박불티"
            }
            .disposed(by: self.disposeBag)
    }
}