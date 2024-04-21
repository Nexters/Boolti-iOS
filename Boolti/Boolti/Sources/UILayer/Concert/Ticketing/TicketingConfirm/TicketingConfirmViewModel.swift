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
        .subscribe(with: self) { owner, response in
            owner.ticketingEntity.orderId = response.orderId
            owner.output.navigateToTossPayments.onNext(())
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
