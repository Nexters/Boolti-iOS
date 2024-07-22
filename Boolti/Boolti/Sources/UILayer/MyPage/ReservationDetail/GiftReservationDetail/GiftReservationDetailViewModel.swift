//
//  GiftReservationDetailViewModel.swift
//  Boolti
//
//  Created by Miro on 7/22/24.
//

import Foundation

import RxSwift
import RxRelay
/*
‼️‼️‼️
TODO: TicketReservationDetailEntity을 ReservationDetailEntityProtocol로 변경해서
 GiftReservationDetail과 TicketReservationDetail을 통합하기..
 현재는 따로 구현!!...
 */

final class GiftReservationDetailViewModel {

    struct Input {
        let viewWillAppearEvent = PublishRelay<Void>()
    }

    struct Output {
        let tickerReservationDetail = BehaviorRelay<GiftReservationDetailEntity?>(value: nil)
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    private let giftReservationsRepository: TicketReservationsRepositoryType
    let giftID: String

    init(giftID: String, giftReservationsRepository: TicketReservationsRepositoryType) {
        self.giftID = giftID
        self.giftReservationsRepository = giftReservationsRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .flatMap { self.fetchGiftReservationDetail() }
            .subscribe(with: self, onNext: { owner, ticketReservationDetail in
                owner.output.tickerReservationDetail.accept(ticketReservationDetail)
            })
            .disposed(by: self.disposeBag)
    }

    private func fetchGiftReservationDetail() -> Single<GiftReservationDetailEntity> {
        return Single.just(GiftReservationDetailEntity(concertPosterImageURLPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/2a94f9f9-ad56-426e-8ff9-aa9f2acafe81", concertTitle: "핫한 공연 예매의 시작, 불티", salesTicketName: "불티 일반 티켓", ticketType: Boolti.TicketType.sale, ticketCount: 1, depositDeadLine: "2024-08-02T23:59:59", paymentMethod: Optional(Boolti.PaymentMethod.simplePayment), totalPaymentAmount: "8,000", reservationStatus: Boolti.ReservationStatus.reservationCompleted, ticketingDate:  Optional("2024-07-11T15:24:01"), salesEndTime: "2024-08-02T23:59:59", csReservationID: "R-64-631", easyPayProvider: Optional("토스페이"), accountTransferBank: nil, paymentCardDetail: nil, showDate: Date(timeIntervalSince1970: 1720305600), giftID: 123, giftMessage: "호호", giftImageURLPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/2a94f9f9-ad56-426e-8ff9-aa9f2acafe81", recipientName: "김용재", recipientPhoneNumber: "0101-234-2342", senderName: "sdf", senderPhoneNumber: "123"))
//        return self.giftReservationsRepository.giftReservationDetail(with: self.giftID)
    }
}
