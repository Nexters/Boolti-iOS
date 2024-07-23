//
//  GiftCompletionViewModel.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import UIKit

import RxSwift
import RxRelay

final class GiftCompletionViewModel {

    // MARK: Properties

    private let disposeBag = DisposeBag()
    private let ticketReservationsRepository: TicketReservationsRepositoryType

    struct Input {
        let viewWillAppearEvent = PublishSubject<Void>()
    }

    struct Output {
        let giftReservationDetail = BehaviorSubject<GiftReservationDetailEntity?>(value: nil)
    }

    let input: Input
    let output: Output
    let giftID: Int

    // MARK: Init

    init(giftID: Int, ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.giftID = giftID
        self.ticketReservationsRepository = ticketReservationsRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .flatMap { self.fetchGiftReservationDetail() }
            .subscribe(with: self) { owner, entity in
                owner.output.giftReservationDetail.onNext(entity)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension GiftCompletionViewModel {

    private func fetchGiftReservationDetail() -> Observable<GiftReservationDetailEntity> {
//        return self.ticketReservationsRepository.giftReservationDetail(with: "\(self.reservationId)")
        return Observable.just(GiftReservationDetailEntity(concertPosterImageURLPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/2a94f9f9-ad56-426e-8ff9-aa9f2acafe81", concertTitle: "핫한 공연 예매의 시작, 불티", salesTicketName: "불티 일반 티켓", ticketType: Boolti.TicketType.sale, ticketCount: 1, depositDeadLine: "2024-08-02T23:59:59", paymentMethod: Optional(Boolti.PaymentMethod.simplePayment), totalPaymentAmount: "8,000", reservationStatus: Boolti.ReservationStatus.reservationCompleted, ticketingDate:  Optional("2024-07-11T15:24:01"), salesEndTime: "2024-08-02T23:59:59", csReservationID: "R-64-631", easyPayProvider: Optional("토스페이"), accountTransferBank: nil, paymentCardDetail: nil, showDate: Date(timeIntervalSince1970: 1720305600), giftID: 123, giftUuid: 123, giftMessage: "호호", giftImageURLPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/2a94f9f9-ad56-426e-8ff9-aa9f2acafe81", recipientName: "김용재", recipientPhoneNumber: "0101-234-2342", senderName: "sdf", senderPhoneNumber: "123"))
    }
}
