//
//  TossPaymentsViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/20/24.
//

import Foundation

import Moya
import RxSwift
import RxRelay
import TossPayments

enum TicketingErrorType: String {
    case noQuantity = "NO_REMAINING_QUANTITY"
    case tossError
}

final class TossPaymentsViewModel {
    
    // MARK: Properties
    
    private let ticketingRepository: TicketingRepositoryType
    private let disposeBag = DisposeBag()
    
    struct Input {
        let successResult = PublishRelay<TossPaymentsResult.Success>()
    }
    
    struct Output {
        let didOrderPaymentCompleted = PublishSubject<TicketingEntity>()
        let didOrderPaymentFailed = PublishSubject<TicketingErrorType>()
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
            .subscribe(with: self) { owner, success in
                owner.orderPayment(success: success)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func orderPayment(success: TossPaymentsResult.Success) {
        self.ticketingRepository.orderPayment(paymentKey: success.paymentKey, amount: Int(success.amount), ticketingEntity: self.ticketingEntity)
            .subscribe(with: self, onSuccess: { owner, response in
                owner.ticketingEntity.reservationId = response.reservationId
                owner.output.didOrderPaymentCompleted.onNext(owner.ticketingEntity)
            }, onFailure: { owner, error in
                guard let error = error as? MoyaError else { return }
                guard let response = error.response else { return }
                let decodedData = try! JSONDecoder().decode(ErrorResponseDTO.self, from: response.data)
                
                switch decodedData.type {
                case TicketingErrorType.noQuantity.rawValue:
                    owner.output.didOrderPaymentFailed.onNext(.noQuantity)
                default:
                    owner.output.didOrderPaymentFailed.onNext(.tossError)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}
