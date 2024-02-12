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
    
    private let concertRepository: ConcertRepository
    private let disposeBag = DisposeBag()
    
    struct Input {
        let didTicketSelect = PublishSubject<SelectedTicketEntity>()
        let didDeleteButtonTap = PublishSubject<Int>()
        let selectedTickets = BehaviorRelay<[SelectedTicketEntity]>(value: [])
    }

    struct Output {
        let isLoading = PublishRelay<Bool>()
        let salesTickets = PublishRelay<[SelectedTicketEntity]>()
        var salesTicketEntities: [SelectedTicketEntity]?
        let totalPrice = BehaviorRelay<Int>(value: 0)
        let showTicketTypeView = PublishRelay<Void>()
    }

    let input: Input
    var output: Output
    
    private let concertId: Int
    
    // MARK: Init

    init(concertRepository: ConcertRepository,
         concertId: Int) {
        self.concertRepository = concertRepository
        self.concertId = concertId
        
        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }
}

// MARK: - Methods

extension TicketSelectionViewModel {
    
    private func bindInputs() {
        self.input.didTicketSelect
            .bind(with: self, onNext: { owner, entity in
                var selectedTickets = owner.input.selectedTickets.value
                selectedTickets.append(entity)

                owner.input.selectedTickets.accept(selectedTickets)
            })
            .disposed(by: self.disposeBag)
        
        self.input.didDeleteButtonTap
            .bind(with: self, onNext: { owner, id in
                var selectedTickets = owner.input.selectedTickets.value
                
                if let indexToRemove = selectedTickets.firstIndex(where: { $0.id == id }) {
                    selectedTickets.remove(at: indexToRemove)
                    owner.input.selectedTickets.accept(selectedTickets)
                }
            })
            .disposed(by: self.disposeBag)
        
        self.input.selectedTickets
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

// MARK: - Network

extension TicketSelectionViewModel {
    
    func fetchSalesTicket(completion: @escaping () -> ()) {
        self.output.isLoading.accept(true)
        self.concertRepository.salesTicket(concertId: self.concertId).asObservable()
            .do { self.output.salesTicketEntities = $0 }
            .subscribe(with: self) { owner, tickets in
                owner.output.salesTickets.accept(tickets)
                owner.output.isLoading.accept(false)
                completion()
            }
            .disposed(by: self.disposeBag)
    }
}
