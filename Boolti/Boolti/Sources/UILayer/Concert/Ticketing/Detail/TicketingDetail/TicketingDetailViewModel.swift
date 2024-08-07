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
    
    struct Input {
        let invitationCode = BehaviorRelay<String>(value: "")
        let ticketHolderName = BehaviorRelay<String>(value: "")
        let ticketHolderPhoneNumber = BehaviorRelay<String>(value: "")
        let depositorName = BehaviorRelay<String>(value: "")
        let depositorPhoneNumber = BehaviorRelay<String>(value: "")
        let isEqualButtonSelected = BehaviorRelay<Bool>(value: false)
        let isAllAgreeButtonSelected = BehaviorRelay<Bool>(value: false)
        let didInvitationCodeUseButtonTap = PublishSubject<Void>()
        let didPayButtonTap = PublishSubject<Void>()
    }
    
    struct Output {
        let invitationCodeState = BehaviorRelay<InvitationCodeState>(value: .empty)
        let isPaybuttonEnable = PublishSubject<Bool>()
        let concertDetail = BehaviorRelay<ConcertDetailEntity?>(value: nil)
        let navigateToConfirm = PublishSubject<Void>()
        var ticketingEntity: TicketingEntity?
    }
    
    var input: Input
    var output: Output
    
    let selectedTicket: SelectedTicketEntity
    
    init(ticketingRepository: TicketingRepository,
         concertRepository: ConcertRepository,
         selectedTicket: SelectedTicketEntity) {
        self.ticketingRepository = ticketingRepository
        self.concertRepository = concertRepository
        self.input = Input()
        self.output = Output()
        self.selectedTicket = selectedTicket
        
        self.bindInputs()
    }
}

// MARK: - Methods

extension TicketingDetailViewModel {
    
    private func bindInputs() {
        self.input.didInvitationCodeUseButtonTap
            .bind(with: self) { owner, _ in
                let code = owner.input.invitationCode.value.trimmingCharacters(in: .whitespaces)
                if code.isEmpty {
                    owner.output.invitationCodeState.accept(.empty)
                } else {
                    owner.checkInvitationCode(invitationCode: code)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.input.didPayButtonTap
            .bind(with: self) { owner, _ in
                switch owner.selectedTicket.ticketType {
                case .sale:
                    owner.setSalesTicketingData()
                case .invitation:
                    owner.setInvitationTicketingData()
                }
            }
            .disposed(by: self.disposeBag)
        
        switch self.selectedTicket.ticketType {
        case .sale:
            if self.selectedTicket.price > 0 {
                Observable.combineLatest(self.checkInputViewTextFieldFilled(isTicketHolder: true),
                                         self.checkInputViewTextFieldFilled(isTicketHolder: false),
                                         self.input.isAllAgreeButtonSelected)
                .map { $0 && $1 && $2 }
                .distinctUntilChanged()
                .bind(to: self.output.isPaybuttonEnable)
                .disposed(by: self.disposeBag)
            } else {
                Observable.combineLatest(self.checkInputViewTextFieldFilled(isTicketHolder: true),
                                         self.input.isAllAgreeButtonSelected)
                .map { $0 && $1 }
                .distinctUntilChanged()
                .bind(to: self.output.isPaybuttonEnable)
                .disposed(by: self.disposeBag)
            }
        case .invitation:
            Observable.combineLatest(self.checkInputViewTextFieldFilled(isTicketHolder: true),
                                     self.output.invitationCodeState,
                                     self.input.isAllAgreeButtonSelected)
            .map { ( isTicketHolderFilled, codeState, isAgree ) in
                return isTicketHolderFilled && codeState == .verified && isAgree
            }
            .distinctUntilChanged()
            .bind(to: self.output.isPaybuttonEnable)
            .disposed(by: self.disposeBag)
        }
    }
    
    private func checkInputViewTextFieldFilled(isTicketHolder: Bool)  -> Observable<Bool> {
        if isTicketHolder {
            return Observable.combineLatest(self.input.ticketHolderName,
                                            self.input.ticketHolderPhoneNumber)
            .map { ticketHolderName, ticketHolderPhoneNumber in
                return !ticketHolderName.trimmingCharacters(in: .whitespaces).isEmpty && !ticketHolderPhoneNumber.trimmingCharacters(in: .whitespaces).isEmpty
            }
        } else {
            return Observable.combineLatest(self.input.depositorName,
                                            self.input.depositorPhoneNumber,
                                            self.input.isEqualButtonSelected)
            .map { depositorName, depositorPhoneNumber, isEqualButtonSelected in
                return isEqualButtonSelected || (!depositorName.trimmingCharacters(in: .whitespaces).isEmpty && !depositorPhoneNumber.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
    
    
    private func checkInvitationCode(invitationCode: String) {
        self.ticketingRepository.checkInvitationCode(concertId: self.selectedTicket.concertId,
                                                     ticketId: self.selectedTicket.id,
                                                     invitationCode: invitationCode)
        .subscribe(with: self, onSuccess: { owner, invitationCodeEntity in
            owner.output.invitationCodeState.accept(invitationCodeEntity.codeState)
        }, onFailure: { owner, _ in
            owner.output.invitationCodeState.accept(.incorrect)
        })
        .disposed(by: self.disposeBag)
    }
    
    private func setSalesTicketingData() {
        guard let concertDetail = self.output.concertDetail.value else { return }
        
        let depositorName = self.input.depositorName.value.isEmpty ? self.input.ticketHolderName.value : self.input.depositorName.value
        let depositorPhoneNumber = self.input.depositorPhoneNumber.value.isEmpty ? self.input.ticketHolderPhoneNumber.value : self.input.depositorPhoneNumber.value
        
        let ticketingEntity = TicketingEntity(concert: concertDetail,
                                              ticketHolder: TicketingEntity.UserInfo(name: self.input.ticketHolderName.value,
                                                                                     phoneNumber: self.input.ticketHolderPhoneNumber.value),
                                              depositor: TicketingEntity.UserInfo(name: depositorName,
                                                                                  phoneNumber: depositorPhoneNumber),
                                              selectedTicket: self.selectedTicket)
        
        self.output.ticketingEntity = ticketingEntity
        self.output.navigateToConfirm.onNext(())
    }
    
    private func setInvitationTicketingData() {
        guard let concertDetail = self.output.concertDetail.value else { return }
        let ticketingEntity = TicketingEntity(concert: concertDetail,
                                              ticketHolder: TicketingEntity.UserInfo(name: self.input.ticketHolderName.value,
                                                                                     phoneNumber: self.input.ticketHolderPhoneNumber.value),
                                              selectedTicket: self.selectedTicket,
                                              invitationCode: self.input.invitationCode.value)
        
        self.output.ticketingEntity = ticketingEntity
        self.output.navigateToConfirm.onNext(())
    }
    
}

// MARK: - Network

extension TicketingDetailViewModel {
    
    func fetchConcertDetail() {
        self.concertRepository.concertDetail(concertId: self.selectedTicket.concertId)
            .asObservable()
            .bind(to: self.output.concertDetail)
            .disposed(by: self.disposeBag)
    }
    
}
