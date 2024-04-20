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
    
    private let ticketingRepository: TicketingRepositoryType
    private let concertRepository: ConcertRepositoryType
    private let disposeBag = DisposeBag()

    struct Output {
        let invitationCodeState = BehaviorRelay<InvitationCodeState>(value: .empty)
        let concertDetail = BehaviorRelay<ConcertDetailEntity?>(value: nil)
        let navigateToConfirm = PublishSubject<Void>()
        var ticketingEntity: TicketingEntity?
    }

    var output: Output
    
    let selectedTicket: BehaviorRelay<SelectedTicketEntity>

    init(ticketingRepository: TicketingRepository,
         concertRepository: ConcertRepository,
         selectedTicket: SelectedTicketEntity) {
        self.ticketingRepository = ticketingRepository
        self.concertRepository = concertRepository
        self.output = Output()
        self.selectedTicket = BehaviorRelay<SelectedTicketEntity>(value: selectedTicket)
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
    
    func setSalesTicketingData(ticketHolderName: String, ticketHolderPhoneNumber: String,
                        depositorName: String, depositorPhoneNumber: String) {
        guard let concertDetail = self.output.concertDetail.value else { return }
        
        let ticketingEntity = TicketingEntity(concert: concertDetail,
                                              ticketHolder: TicketingEntity.userInfo(name: ticketHolderName,
                                                                                     phoneNumber: ticketHolderPhoneNumber),
                                              depositor: TicketingEntity.userInfo(name: depositorName.isEmpty ? ticketHolderName : depositorName,
                                                                                  phoneNumber: depositorPhoneNumber.isEmpty ? ticketHolderPhoneNumber : depositorName),
                                              selectedTicket: self.selectedTicket.value,
                                              reservationId: "")
        
        self.output.ticketingEntity = ticketingEntity
        self.output.navigateToConfirm.onNext(())
    }
    
    func checkInvitationCode(invitationCode: String) {
        self.ticketingRepository.checkInvitationCode(concertId: self.selectedTicket.value.concertId,
                                                   ticketId: self.selectedTicket.value.id,
                                                   invitationCode: invitationCode)
        .subscribe(with: self, onSuccess: { owner, invitationCodeEntity in
            owner.output.invitationCodeState.accept(invitationCodeEntity.codeState)
        }, onFailure: { owner, _ in
            owner.output.invitationCodeState.accept(.incorrect)
        })
        .disposed(by: self.disposeBag)
    }
    
    func setInvitationTicketingData(ticketHolderName: String,
                                    ticketHolderPhoneNumber: String,
                                    invitationCode: String) {
        guard let concertDetail = self.output.concertDetail.value else { return }
        let ticketingEntity = TicketingEntity(concert: concertDetail,
                                              ticketHolder: TicketingEntity.userInfo(name: ticketHolderName,
                                                                                     phoneNumber: ticketHolderPhoneNumber),
                                              selectedTicket: self.selectedTicket.value,
                                              reservationId: "",
                                              invitationCode: invitationCode)
        
        self.output.ticketingEntity = ticketingEntity
        self.output.navigateToConfirm.onNext(())
    }
}
