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
        let didFreeOrderPaymentFailed = PublishSubject<Void>()
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
                case .sale: 
                    if owner.ticketingEntity.selectedTicket.price == 0 {
                        owner.freeSalesTicketing()
                    } else {
                        owner.savePaymentInfo()
                    }
                case .invitation: owner.invitationTicketing()
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
        self.ticketingRepository.freeTicketing(selectedTicket: self.ticketingEntity.selectedTicket,
                                               ticketHolderName: self.ticketingEntity.ticketHolder.name,
                                               ticketHolderPhoneNumber: self.ticketingEntity.ticketHolder.phoneNumber)
        .subscribe(with: self, onSuccess: { owner, response in
            owner.ticketingEntity.reservationId = response.reservationId
            owner.output.navigateToCompletion.onNext(())
        }, onFailure: { owner, error in
            owner.output.didFreeOrderPaymentFailed.onNext(())
        })
        .disposed(by: self.disposeBag)
    }
    
    private func invitationTicketing() {
        guard let invitationCode = self.ticketingEntity.invitationCode else { return }
        
        self.ticketingRepository.invitationTicketing(selectedTicket: self.ticketingEntity.selectedTicket,
                                                   ticketHolderName: self.ticketingEntity.ticketHolder.name,
                                                   ticketHolderPhoneNumber: self.ticketingEntity.ticketHolder.phoneNumber,
                                                   invitationCode: invitationCode)
        .do { self.ticketingEntity.reservationId = $0.reservationId }
        .subscribe(with: self) { owner, _ in
            owner.output.navigateToCompletion.onNext(())
        }
        .disposed(by: self.disposeBag)
    }
}
