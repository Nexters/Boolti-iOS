//
//  TicketSelectionViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import Foundation
import RxSwift
import RxRelay

final class TicketSelectionViewModel {
    
    // MARK: Properties
    
//    private let ticketAPIService: TicketAPIServiceType
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectedTickets = BehaviorRelay<[TicketEntity]>(value: [])
    }

    struct Output {
        // TODO: 데이터 체크용. api 연결후 []로 초기화 예정
        let tickets = BehaviorRelay<[TicketEntity]>(value: [.init(id: 0, name: "초청 티켓", price: 0, inventory: 100),
                                                            .init(id: 1, name: "일반 티켓 A", price: 3000, inventory: 0),
                                                            .init(id: 2, name: "일반 티켓 B", price: 5000, inventory: 300),
                                                            .init(id: 2, name: "일반 티켓 C", price: 15000, inventory: 10)])
        let totalPrice = BehaviorSubject<Int>(value: 0)
    }

    let input: Input
    let output: Output
    
    // MARK: Init

//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
    init() {
        self.input = Input()
        self.output = Output()
        
        self.bindInputs()
    }
}

// MARK: - Methods

extension TicketSelectionViewModel {
    
    private func bindInputs() {
        self.input.selectedTickets
            .map { ticket in
                return ticket.reduce(0) { $0 + $1.price }
            }
            .bind(to: self.output.totalPrice)
            .disposed(by: self.disposeBag)
    }
}
