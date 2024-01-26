//
//  TicketPreviewViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import Foundation
import RxSwift
import RxRelay

final class TicketPreviewViewModel {
    
//    private let ticketAPIService: TicketAPIServiceType
    
    private let disposeBag = DisposeBag()
    
    struct Input {
    }

    struct Output {
        let tickets = BehaviorRelay<[TicketEntity]>(value: [.init(id: 0, name: "일반 티켓B", price: 5000, inventory: 100)])
        var totalPrice = BehaviorSubject<Int>(value: 0)
    }

    let input: Input
    let output: Output

//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
    init() {
        self.input = Input()
        self.output = Output()
        
        self.reducePrice()
    }
}

// MARK: - Methods

extension TicketPreviewViewModel {
    
    private func reducePrice() {
        self.output.tickets
            .map { ticket in
                return ticket.reduce(0) { $0 + $1.price }
            }
            .bind(to: output.totalPrice)
            .disposed(by: disposeBag)
    }
}
