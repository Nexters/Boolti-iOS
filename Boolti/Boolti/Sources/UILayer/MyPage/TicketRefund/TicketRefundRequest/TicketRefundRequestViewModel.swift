//
//  TicketRefundRequestViewModel.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import Foundation

import RxSwift
import RxRelay

final class TicketRefundRequestViewModel {

    struct Input {
        let viewWillAppearEvent = PublishRelay<Void>()
        let selectedItem = PublishRelay<BankEntity>()
        let accoundHolderNameText = BehaviorRelay<String>(value: "")
        let accountHolderPhoneNumberText = BehaviorRelay<String>(value: "")
        let refundAccountNumberText = BehaviorRelay<String>(value: "")
    }

    struct Output {
        let tickerReservationDetail = PublishRelay<TicketReservationDetailEntity>()
        let isAccoundHolderNameEmpty = PublishRelay<Bool>()
        let isAccoundHolderPhoneNumberEmpty = PublishRelay<Bool>()
        let selectedBank = BehaviorRelay<BankEntity?>(value: nil)
        let isValidrefundAccountNumber = PublishRelay<Bool>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()


    let reservationID: String
    let reasonText: String
    private let ticketReservationsRepository: TicketReservationsRepositoryType

    init(reservationID: String, reasonText: String, ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.reservationID = reservationID
        self.reasonText = reasonText
        self.ticketReservationsRepository = ticketReservationsRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .flatMap { self.fetchReservationDetail() }
            .subscribe(with: self, onNext: { owner, ticketReservationDetail in
                owner.output.tickerReservationDetail.accept(ticketReservationDetail)
            })
            .disposed(by: self.disposeBag)

        self.input.accoundHolderNameText
            .subscribe(with: self) { owner, text in
                owner.output.isAccoundHolderNameEmpty.accept(text.isEmpty)
            }
            .disposed(by: self.disposeBag)

        self.input.accountHolderPhoneNumberText
            .subscribe(with: self) { owner, text in
                owner.output.isAccoundHolderPhoneNumberEmpty.accept(text.isEmpty)
            }
            .disposed(by: self.disposeBag)

        self.input.refundAccountNumberText
            .map { self.checkAccountNumber($0)}
            .subscribe(with: self) { owner, isValid in
                owner.output.isValidrefundAccountNumber.accept(isValid)
            }
            .disposed(by: self.disposeBag)

        self.input.selectedItem
            .subscribe(with: self) { owner, bankEntity in
                owner.output.selectedBank.accept(bankEntity)
            }
            .disposed(by: self.disposeBag)
    }

    private func fetchReservationDetail() -> Single<TicketReservationDetailEntity> {
        return self.ticketReservationsRepository.ticketReservationDetail(with: self.reservationID)
    }

    private func checkAccountNumber(_ text: String) -> Bool {
        let phoneNumberPattern = #"^\d{11,14}$"#
        return text.range(of: phoneNumberPattern, options: .regularExpression) != nil
    }
}
