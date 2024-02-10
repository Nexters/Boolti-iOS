//
//  TicketReservationsViewModel.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

import RxSwift
import RxRelay

final class TicketReservationsViewModel {

    struct Input {
        let viewWillAppearEvent = PublishRelay<Void>()
    }

    struct Output {
        let tickerReservations = PublishRelay<[TicketReservationItemEntity]>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()
    private let networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .subscribe(with: self) { owner, _ in
                owner.output.tickerReservations.accept([
                    TicketReservationItemEntity(reservationID: 1, reservationStatus: .reservationCompleted, reservationDate: "2024-02-09T11:54:42.567Z", concertTitle: "윤민이의 임재범 고해", concertImageURLPath: "https://booltiapi.s3.ap-northeast-2.amazonaws.com/show/1/1.jpg", ticketName: "일반석", ticketCount: 2, ticketPrice: 10000),TicketReservationItemEntity(reservationID: 1, reservationStatus: .reservationCompleted, reservationDate: "2024-02-09T11:54:42.567Z", concertTitle: "윤민이의 임재범 고해", concertImageURLPath: "https://booltiapi.s3.ap-northeast-2.amazonaws.com/show/1/1.jpg", ticketName: "일반석", ticketCount: 2, ticketPrice: 10000),TicketReservationItemEntity(reservationID: 1, reservationStatus: .reservationCompleted, reservationDate: "2024-02-09T11:54:42.567Z", concertTitle: "윤민이의 임재범 고해", concertImageURLPath: "https://booltiapi.s3.ap-northeast-2.amazonaws.com/show/1/1.jpg", ticketName: "일반석", ticketCount: 2, ticketPrice: 10000),
                ])
            }
            .disposed(by: self.disposeBag)
    }



}
