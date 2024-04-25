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
        let csReservationId = PublishRelay<String>()
        let bankName = PublishRelay<String>()
        let installmentPlanMonths = PublishRelay<Int>()
    }
    
    let output: Output
    let ticketingData: TicketingEntity

    // MARK: Init
    
    init(ticketingEntity: TicketingEntity,
         ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.output = Output()
        self.ticketingData = ticketingEntity
        self.ticketReservationsRepository = ticketReservationsRepository
        self.fetchReservationDetail()
    }
    
}

// MARK: - Network

extension TicketingCompletionViewModel {
    
    private func fetchReservationDetail() {
        self.ticketReservationsRepository.ticketReservationDetail(with: "\(self.ticketingData.reservationId)")
            .subscribe(with: self) { owner, response in
                owner.output.csReservationId.accept(response.csReservationID)
                owner.output.bankName.accept(response.bankName)
                owner.output.installmentPlanMonths.accept(response.installmentPlanMonths)
            }
            .disposed(by: self.disposeBag)
    }
    
}
