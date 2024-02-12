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
    
    // MARK: Properties
    
    private let concertRepository: ConcertRepositoryType
    private let disposeBag = DisposeBag()
    
    struct Input {
        var ticketingEntity: TicketingEntity?
    }

    struct Output {
        let invitationCodeState = BehaviorRelay<InvitationCodeState>(value: .empty)
        let concertDetail = PublishRelay<ConcertDetailEntity>()
        var concertDetailEntity: ConcertDetailEntity?
        let navigateToCompletion = PublishSubject<Void>()
    }

    var input: Input
    var output: Output
    
    let selectedTicket: BehaviorRelay<SelectedTicketEntity>

    init(concertRepository: ConcertRepository,
         selectedTicket: SelectedTicketEntity) {
        self.concertRepository = concertRepository
        self.input = Input()
        self.output = Output()
        self.selectedTicket = BehaviorRelay<SelectedTicketEntity>(value: selectedTicket)
    }
}

// MARK: - Network

extension TicketingDetailViewModel {
    
    func fetchConcertDetail() {
        self.concertRepository.concertDetail(concertId: self.selectedTicket.value.concertId)
            .do { self.output.concertDetailEntity = $0 }
            .asObservable()
            .bind(to: self.output.concertDetail)
            .disposed(by: self.disposeBag)
    }
    
    func salesTicketing(ticketHolderName: String, ticketHolderPhoneNumber: String,
                        depositorName: String, depositorPhoneNumber: String) {
        self.concertRepository.salesTicketing(selectedTicket: self.selectedTicket.value,
                                              ticketHolderName: ticketHolderName,
                                              ticketHolderPhoneNumber: ticketHolderPhoneNumber,
                                              depositorName: depositorName,
                                              depositorPhoneNumber: depositorPhoneNumber)
        .subscribe(with: self) { owner, _ in
            let ticketingEntity = TicketingEntity(concert: owner.output.concertDetailEntity!,
                                                  ticketHolder: TicketingEntity.userInfo(name: ticketHolderName,
                                                                                         phoneNumber: ticketHolderPhoneNumber),
                                                  depositor: TicketingEntity.userInfo(name: depositorName,
                                                                                      phoneNumber: depositorPhoneNumber),
                                                  selectedTicket: [owner.selectedTicket.value])
            owner.input.ticketingEntity = ticketingEntity
            
            owner.output.navigateToCompletion.onNext(())
        }
        .disposed(by: self.disposeBag)
    }
    
    func checkInvitationCode(invitationCode: String) {
        self.concertRepository.checkInvitationCode(concertId: self.selectedTicket.value.concertId,
                                                   ticketId: self.selectedTicket.value.id,
                                                   invitationCode: invitationCode)
        .subscribe(with: self, onSuccess: { owner, invitationCodeEntity in
            owner.output.invitationCodeState.accept(invitationCodeEntity.codeState)
        }, onFailure: { owner, _ in
            owner.output.invitationCodeState.accept(.incorrect)
        })
        .disposed(by: self.disposeBag)
    }
    
    func invitationTicketing(ticketHolderName: String,
                             ticketHolderPhoneNumber: String,
                             invitationCode: String) {
        self.concertRepository.invitationTicketing(selectedTicket: self.selectedTicket.value,
                                                   ticketHolderName: ticketHolderName,
                                                   ticketHolderPhoneNumber: ticketHolderPhoneNumber,
                                                   invitationCode: invitationCode)
        .subscribe(with: self) { owner, _ in
            let ticketingEntity = TicketingEntity(concert: owner.output.concertDetailEntity!,
                                                  ticketHolder: TicketingEntity.userInfo(name: ticketHolderName,
                                                                                         phoneNumber: ticketHolderPhoneNumber),
                                                  selectedTicket: [owner.selectedTicket.value],
                                                  invitationCode: invitationCode)
            owner.input.ticketingEntity = ticketingEntity
            
            owner.output.navigateToCompletion.onNext(())
        }
        .disposed(by: self.disposeBag)
    }
}
