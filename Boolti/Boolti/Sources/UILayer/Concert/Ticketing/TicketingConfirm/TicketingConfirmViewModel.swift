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
    
    private let concertRepository: ConcertRepositoryType
    private let disposeBag = DisposeBag()
    
    struct Input {
        let didPayButtonTap = PublishSubject<Void>()
    }

    struct Output {
        let navigateToCompletion = PublishSubject<Void>()
    }

    var input: Input
    var output: Output
    
    var ticketingEntity: TicketingEntity

    init(concertRepository: ConcertRepository,
         ticketingEntity: TicketingEntity) {
        self.concertRepository = concertRepository
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
                guard let selectedTicket = owner.ticketingEntity.selectedTicket.first else { return }
        
                switch selectedTicket.ticketType {
                case .sales: self.salesTicketing()
                case .invite: self.invitationTicketing()
                }
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension TicketingConfirmViewModel {
    
    private func salesTicketing() {
        guard let selectedTicket = self.ticketingEntity.selectedTicket.first,
              let depositor = self.ticketingEntity.depositor else { return }
        
        self.concertRepository.salesTicketing(selectedTicket: selectedTicket,
                                              ticketHolderName: self.ticketingEntity.ticketHolder.name,
                                              ticketHolderPhoneNumber: self.ticketingEntity.ticketHolder.phoneNumber,
                                              depositorName: depositor.name,
                                              depositorPhoneNumber: depositor.phoneNumber)
        .subscribe(with: self) { owner, response in
            self.ticketingEntity.reservationId = response.reservationId
            owner.output.navigateToCompletion.onNext(())
        }
        .disposed(by: self.disposeBag)
    }
    
    private func invitationTicketing() {
        guard let selectedTicket = self.ticketingEntity.selectedTicket.first,
              let invitationCode = self.ticketingEntity.invitationCode else { return }
        
        self.concertRepository.invitationTicketing(selectedTicket: selectedTicket,
                                                   ticketHolderName: self.ticketingEntity.ticketHolder.name,
                                                   ticketHolderPhoneNumber: self.ticketingEntity.ticketHolder.phoneNumber,
                                                   invitationCode: invitationCode)
        .subscribe(with: self) { owner, _ in
            owner.output.navigateToCompletion.onNext(())
        }
        .disposed(by: self.disposeBag)
    }
}
