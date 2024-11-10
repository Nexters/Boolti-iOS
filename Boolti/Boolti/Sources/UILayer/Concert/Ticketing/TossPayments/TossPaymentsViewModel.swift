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

final class TossPaymentsViewModel {
    
    // MARK: Properties
    
    private let ticketingRepository: TicketingRepositoryType
    private let giftingRepository: GiftingRepositoryType
    private let disposeBag = DisposeBag()
    
    struct Input {
        let successResult = PublishRelay<TossPaymentsResult.Success>()
    }
    
    struct Output {
        let didOrderPaymentCompleted = PublishSubject<Int>()
        let didOrderPaymentFailed = PublishSubject<TicketingErrorType>()
    }
    
    var input: Input
    var output: Output
    
    var ticketingEntity: TicketingEntity?
    var giftingEntity: GiftingEntity?
    var type: TicketingType
    
    // MARK: Initailizer
    
    init(ticketingRepository: TicketingRepositoryType,
         giftingRepository: GiftingRepositoryType,
         ticketingEntity: TicketingEntity?,
         giftingEntity: GiftingEntity?,
         type: TicketingType
    ) {
        self.input = Input()
        self.output = Output()
        self.ticketingRepository = ticketingRepository
        self.giftingRepository = giftingRepository
        self.ticketingEntity = ticketingEntity
        self.giftingEntity = giftingEntity
        self.type = type
        
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
        switch self.type {
        case .ticketing: self.orderTicketing(success: success)
        case .gifting: self.orderGifting(success: success)
            
        }
    }
    
    private func orderTicketing(success: TossPaymentsResult.Success) {
        guard let ticketingEntity = self.ticketingEntity else { return }
        self.ticketingRepository.orderPayment(paymentKey: success.paymentKey,
                                              amount: Int(success.amount),
                                              ticketingEntity: ticketingEntity)
        .subscribe(with: self, onSuccess: { owner, response in
            owner.output.didOrderPaymentCompleted.onNext(response.reservationId)
        }, onFailure: { owner, error in
            guard let error = error as? MoyaError else { return }
            guard let response = error.response else { return }
            guard let decodedData = try? JSONDecoder().decode(TicketingErrorResponseDTO.self, from: response.data) else {
                owner.output.didOrderPaymentFailed.onNext(.tossError)
                return
            }
            
            guard let ticketingError = TicketingErrorType(rawValue: decodedData.tossMessage) else { return }
            owner.output.didOrderPaymentFailed.onNext(ticketingError)
        })
        .disposed(by: self.disposeBag)
    }
    
    private func orderGifting(success: TossPaymentsResult.Success) {
        guard let giftingEntity = self.giftingEntity else { return }
        self.giftingRepository.orderGiftPayment(paymentKey: success.paymentKey,
                                                amount: Int(success.amount),
                                                giftingEntity: giftingEntity)
        .subscribe(with: self, onSuccess: { owner, response in
            owner.output.didOrderPaymentCompleted.onNext(response.giftId)
        }, onFailure: { owner, error in
            guard let error = error as? MoyaError else { return }
            guard let response = error.response else { return }
            guard let decodedData = try? JSONDecoder().decode(TicketingErrorResponseDTO.self, from: response.data) else {
                owner.output.didOrderPaymentFailed.onNext(.tossError)
                return
            }
            
            guard let ticketingError = TicketingErrorType(rawValue: decodedData.tossMessage) else { return }
            owner.output.didOrderPaymentFailed.onNext(ticketingError)
        })
        .disposed(by: self.disposeBag)
    }
    
}
