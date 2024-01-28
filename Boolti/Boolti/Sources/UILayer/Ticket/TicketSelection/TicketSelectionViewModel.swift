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
        let didTicketSelect = PublishSubject<TicketEntity>()
        let didDeleteButtonTap = PublishSubject<Int>()
    }

    struct Output {
        // TODO: 데이터 체크용. api 연결후 []로 초기화 예정
        let tickets = BehaviorRelay<[TicketEntity]>(value: [.init(id: 0, name: "초청 티켓", price: 0, inventory: 100),
                                                            .init(id: 1, name: "일반 티켓 A", price: 3000, inventory: 0),
                                                            .init(id: 2, name: "일반 티켓 B", price: 5000, inventory: 300),
                                                            .init(id: 2, name: "일반 티켓 C", price: 15000, inventory: 10)])
        let selectedTickets = BehaviorRelay<[TicketEntity]>(value: [])
        let totalPrice = BehaviorRelay<Int>(value: 0)
        let showTicketTypeView = PublishRelay<Void>()
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
        self.bindOutputs()
    }
}

// MARK: - Methods

extension TicketSelectionViewModel {
    
    private func bindInputs() {
        self.input.didTicketSelect
            .bind(with: self, onNext: { owner, entity in
                var selectedTickets = owner.output.selectedTickets.value
                selectedTickets.append(entity)

                owner.output.selectedTickets.accept(selectedTickets)
            })
            .disposed(by: self.disposeBag)
        
        self.input.didDeleteButtonTap
            .bind(with: self, onNext: { owner, id in
                var selectedTickets = owner.output.selectedTickets.value
                
                if let indexToRemove = selectedTickets.firstIndex(where: { $0.id == id }) {
                    selectedTickets.remove(at: indexToRemove)
                    owner.output.selectedTickets.accept(selectedTickets)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.output.selectedTickets
            .asDriver()
            .drive(with: self, onNext: { owner, tickets in
                if tickets.isEmpty {
                    owner.output.showTicketTypeView.accept(())
                } else {
                    let totalPrice = tickets.reduce(0) { $0 + $1.price }
                    owner.output.totalPrice.accept(totalPrice)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
