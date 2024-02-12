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
        let navigateToCompletion = PublishSubject<Void>()
    }

    var input: Input
    let output: Output
    
    let selectedTicket: BehaviorRelay<SalesTicketEntity>

    init(concertRepository: ConcertRepository,
         selectedTicket: SalesTicketEntity) {
        self.concertRepository = concertRepository
        self.input = Input()
        self.output = Output()
        self.selectedTicket = BehaviorRelay<SalesTicketEntity>(value: selectedTicket)
    }
}

// MARK: - Network

extension TicketingDetailViewModel {
    
    func fetchConcertDetail() {
        self.concertRepository.concertDetail(concertId: self.selectedTicket.value.concertId)
            .asObservable()
            .bind(to: self.output.concertDetail)
            .disposed(by: self.disposeBag)
    }
    
    func salesTicketing(ticketHolderName: String, ticketHolderPhoneNumber: String,
                        depositorName: String, depositorPhoneNumber: String) {
        self.concertRepository.salesTicketing(concertId: self.selectedTicket.value.concertId,
                                              selectedTicket: self.selectedTicket.value,
                                              ticketHolderName: ticketHolderName,
                                              ticketHolderPhoneNumber: ticketHolderPhoneNumber,
                                              depositorName: depositorName,
                                              depositorPhoneNumber: depositorPhoneNumber)
        .subscribe(with: self) { owner, _ in
            owner.output.navigateToCompletion.onNext(())
        }
        .disposed(by: self.disposeBag)
    }
    
    func checkInvitationCode(invitationCode: String) {
        debugPrint(self.selectedTicket.value.concertId, self.selectedTicket.value.id)
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
    
    func invitationTicketing(ticketHolderName: String, ticketHolderPhoneNumber: String,
                             invitationCode: String) {
        debugPrint(ticketHolderName, ticketHolderPhoneNumber, invitationCode)
        
        // TODO: 초청코드 티켓팅 연결
    }
}
