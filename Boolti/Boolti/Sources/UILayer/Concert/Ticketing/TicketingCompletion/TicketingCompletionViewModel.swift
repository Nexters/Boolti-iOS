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

    let ticketingData: BehaviorRelay<TicketingEntity>

    // MARK: Init
    
    init(ticketingEntity: TicketingEntity,
         ticketReservationsRepository: TicketReservationsRepositoryType) {
        self.ticketingData = BehaviorRelay<TicketingEntity>(value: ticketingEntity)
        self.ticketReservationsRepository = ticketReservationsRepository
    }
    
}
