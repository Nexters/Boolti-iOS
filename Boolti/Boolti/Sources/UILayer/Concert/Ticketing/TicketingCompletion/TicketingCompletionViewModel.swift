//
//  TicketingCompletionViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit

import RxSwift
import RxRelay

final class TicketingCompletionViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let ticketReservationsRepository: TicketReservationsRepositoryType
    
    struct Output {
        let reservationDetail = PublishRelay<TicketReservationDetailEntity>()
    }
    
    let output: Output
    let reservationId: Int

    // MARK: Init
    
    init(reservationId: Int,
         ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.output = Output()
        self.reservationId = reservationId
        self.ticketReservationsRepository = ticketReservationsRepository
        self.fetchReservationDetail()
    }
    
}

// MARK: - Network

extension TicketingCompletionViewModel {
    
    private func fetchReservationDetail() {
        self.ticketReservationsRepository.ticketReservationDetail(with: "\(self.reservationId)")
            .subscribe(with: self) { owner, response in
                owner.output.reservationDetail.accept(response)
            }
            .disposed(by: self.disposeBag)
    }
    
}
