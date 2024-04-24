//
//  TicketingConfirmViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/26/24.
//

import Foundation

import RxSwift
import RxRelay

final class TicketingConfirmViewModel {
    
    // MARK: Properties
    
    private let ticketingRepository: TicketingRepositoryType
    private let disposeBag = DisposeBag()
    
    struct Input {
        let didPayButtonTap = PublishSubject<Void>()
    }

    struct Output {
        let navigateToTossPayments = PublishSubject<Void>()
        let navigateToCompletion = PublishSubject<Void>()
    }

    var input: Input
    var output: Output
    
    var ticketingEntity: TicketingEntity

    init(ticketingRepository: TicketingRepositoryType,
         ticketingEntity: TicketingEntity) {
        self.ticketingRepository = ticketingRepository
        self.input = Input()
        self.output = Output()
        self.ticketingEntity = ticketingEntity
        
        self.bindInputs()
    }
}

// MARK: - Methods

extension TicketingConfirmViewModel {
    
    private func bindInputs() {
        self.input.didPayButtonTap
            .bind(with: self) { owner, _ in
                switch owner.ticketingEntity.selectedTicket.ticketType {
                case .sale: self.savePaymentInfo()
                case .invitation: self.invitationTicketing()
                case .free: self.freeSalesTicketing()
                }
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension TicketingConfirmViewModel {
    
    private func savePaymentInfo() {
        self.ticketingRepository.savePaymentInfo(concertId: self.ticketingEntity.concert.id,
                                                 selectedTicket: self.ticketingEntity.selectedTicket)
        .do { self.ticketingEntity.orderId = $0.orderId }
        .subscribe(with: self) { owner, response in
            owner.output.navigateToTossPayments.onNext(())
        }
        .disposed(by: self.disposeBag)
    }
    
    private func freeSalesTicketing() {
        self.ticketingRepository.orderPayment(paymentKey: "", amount: 0, ticketingEntity: self.ticketingEntity)
            .do { self.ticketingEntity.reservationId = $0.reservationId }
            .subscribe(with: self) { owner, response in
                owner.output.navigateToCompletion.onNext(())
            }
            .disposed(by: self.disposeBag)
    }
    
    private func invitationTicketing() {
        guard let invitationCode = self.ticketingEntity.invitationCode else { return }
        
        self.ticketingRepository.invitationTicketing(selectedTicket: self.ticketingEntity.selectedTicket,
                                                   ticketHolderName: self.ticketingEntity.ticketHolder.name,
                                                   ticketHolderPhoneNumber: self.ticketingEntity.ticketHolder.phoneNumber,
                                                   invitationCode: invitationCode)
        .subscribe(with: self) { owner, _ in
            owner.output.navigateToCompletion.onNext(())
        }
        .disposed(by: self.disposeBag)
    }
}
