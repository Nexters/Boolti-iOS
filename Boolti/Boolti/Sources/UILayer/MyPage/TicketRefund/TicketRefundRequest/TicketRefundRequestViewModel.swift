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
        let accoundHolderNameText = BehaviorRelay<String>(value: "")
        let accountHolderPhoneNumberText = BehaviorRelay<String>(value: "")
        let refundAccountNumberText = BehaviorRelay<String>(value: "")
    }

    struct Output {
        let tickerReservationDetail = PublishRelay<TicketReservationDetailEntity>()
        let isValidAccoundHolderName = PublishRelay<Bool>()
        let isValidAccoundHolderPhoneNumber = PublishRelay<Bool>()
        let isValidrefundAccountNumber = PublishRelay<Bool>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()


    private let reservationID: String
    private let reasonText: String
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
            .map { self.checkName($0) }
            .subscribe(with: self) { owner, isValid in
                owner.output.isValidAccoundHolderName.accept(isValid)
            }
            .disposed(by: self.disposeBag)

        self.input.accountHolderPhoneNumberText
            .map { self.checkPhoneNumber($0)}
            .subscribe(with: self) { owner, isValid in
                owner.output.isValidAccoundHolderPhoneNumber.accept(isValid)
            }
            .disposed(by: self.disposeBag)

        self.input.refundAccountNumberText
            .map { self.checkAccountNumber($0)}
            .subscribe(with: self) { owner, isValid in
                owner.output.isValidrefundAccountNumber.accept(isValid)
            }
            .disposed(by: self.disposeBag)
    }

    private func fetchReservationDetail() -> Single<TicketReservationDetailEntity> {
        return self.ticketReservationsRepository.ticketReservationDetail(with: self.reservationID)
    }

    private func checkName(_ text: String) -> Bool {
        let koreanPattern = "^[가-힣]*$"
        return text.range(of: koreanPattern, options: .regularExpression) != nil
    }

    private func checkPhoneNumber(_ text: String) -> Bool {
        guard text.hasPrefix("010") else { return false }
        return true
    }

    private func checkAccountNumber(_ text: String) -> Bool {
        let phoneNumberPattern = #"^\d{11,13}$"#
        return text.range(of: phoneNumberPattern, options: .regularExpression) != nil
    }

}
