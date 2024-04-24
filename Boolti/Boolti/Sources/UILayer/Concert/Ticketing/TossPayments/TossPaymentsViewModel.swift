//
//  TossPaymentsViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/20/24.
//

import RxSwift
import RxRelay
import TossPayments

final class TossPaymentsViewModel {
    
    // MARK: Properties
    
    private let ticketingRepository: TicketingRepositoryType
    private let disposeBag = DisposeBag()
    
    struct Input {
        let successResult = PublishRelay<TossPaymentsResult.Success>()
    }
    
    struct Output {
        let didOrderPaymentCompleted = PublishSubject<TicketingEntity>()
    }

    var input: Input
    var output: Output

    var ticketingEntity: TicketingEntity
    
    // MARK: Initailizer
    
    init(ticketingRepository: TicketingRepositoryType,
         ticketingEntity: TicketingEntity) {
        self.input = Input()
        self.output = Output()
        self.ticketingRepository = ticketingRepository
        self.ticketingEntity = ticketingEntity
        self.bindInputs()
    }
    
}

// MARK: - Methods

extension TossPaymentsViewModel {
    
    private func bindInputs() {
        self.input.successResult
            .flatMap { self.orderPayment(success: $0) }
            .do { self.ticketingEntity.reservationId = $0.reservationId }
            .subscribe(with: self) { owner, _ in
                owner.output.didOrderPaymentCompleted.onNext(owner.ticketingEntity)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func orderPayment(success: TossPaymentsResult.Success) -> Single<OrderPaymentResponseDTO> {
        return self.ticketingRepository.orderPayment(paymentKey: success.paymentKey, amount: Int(success.amount), ticketingEntity: self.ticketingEntity)
    }
    
}
