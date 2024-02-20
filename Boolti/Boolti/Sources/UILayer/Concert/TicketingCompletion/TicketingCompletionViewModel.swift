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
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let ticketReservationsRepository: TicketReservationsRepositoryType
    
    struct Input {
        let didCopyButtonTap = PublishSubject<Void>()
    }
    
    struct Output {
        let reservationDetail = PublishRelay<TicketReservationDetailEntity>()
    }

    let input: Input
    let output: Output
    
    let ticketingData: BehaviorRelay<TicketingEntity>
    var copyData: String = ""

    // MARK: Init
    
    init(ticketingEntity: TicketingEntity,
         ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.input = Input()
        self.output = Output()
        self.ticketingData = BehaviorRelay<TicketingEntity>(value: ticketingEntity)
        self.ticketReservationsRepository = ticketReservationsRepository
        
        self.bindInputs()
        self.fetchReservationDetail()
    }
}

// MARK: - Methods

extension TicketingCompletionViewModel {
    
    private func bindInputs() {
        self.input.didCopyButtonTap
            .bind(with: self) { owner, _ in
                UIPasteboard.general.string = owner.copyData
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension TicketingCompletionViewModel {
    
    private func fetchReservationDetail() {
        self.ticketReservationsRepository.ticketReservationDetail(with: String(self.ticketingData.value.reservationId))
            .do { self.copyData = "\($0.bankName) \($0.accountNumber) \($0.accountHolderName)" }
            .asObservable()
            .bind(to: self.output.reservationDetail)
            .disposed(by: self.disposeBag)
    }
}
