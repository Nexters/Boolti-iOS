//
//  TicketingDetailViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import Foundation
import RxSwift
import RxRelay

final class TicketingDetailViewModel {
    
//    private let ticketAPIService: TicketAPIServiceType
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let didUseButtonTap = PublishSubject<Void>()
    }

    struct Output {
        let selectedTicket: BehaviorRelay<TicketEntity>
        let invitationCodeState = BehaviorRelay<InvitationCodeState>(value: .empty)
    }

    let input: Input
    let output: Output

//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
    init(selectedTicket: TicketEntity) {
        self.input = Input()
        self.output = Output(selectedTicket: BehaviorRelay<TicketEntity>(value: selectedTicket))
        
        self.bindInputs()
    }
}

// MARK: - Methods

extension TicketingDetailViewModel {
    
    private func bindInputs() {
        self.input.didUseButtonTap
            .subscribe(with: self) { owner, _ in
                
                // 서버에서 state 확인 후 수정
                owner.output.invitationCodeState.accept(.verified)
            }
            .disposed(by: self.disposeBag)
    }
}
