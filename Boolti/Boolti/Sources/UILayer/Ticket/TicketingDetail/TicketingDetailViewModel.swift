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
    
//    private let ticketAPIService: TicketAPIServiceType
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectedTicket = PublishRelay<TicketEntity>()
    }

    struct Output {
    }

    let input: Input
    let output: Output

//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
    init(selectedTicket: TicketEntity) {
        self.input = Input()
        self.output = Output()
        
        self.input.selectedTicket.accept(selectedTicket)
    }
}
