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
        let didDeleteButtonTap = PublishSubject<Void>()
        let selectedTicket = BehaviorRelay<SelectedTicketEntity?>(value: nil)
    }

    struct Output {
        let isLoading = PublishRelay<Bool>()
        let salesTickets = BehaviorRelay<[SelectedTicketEntity]>(value: [])
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
            .bind(to: self.input.selectedTicket)
            .disposed(by: self.disposeBag)
        
        self.input.didDeleteButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.input.selectedTicket.accept(nil)
            })
            .disposed(by: self.disposeBag)
        
        self.input.selectedTicket
            .asDriver()
            .drive(with: self, onNext: { owner, ticket in
                if ticket == nil {
                    owner.output.showTicketTypeView.accept(())
                } else {
                    guard let ticket = ticket else { return }
                    owner.output.totalPrice.accept(ticket.price * ticket.count)
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
            .subscribe(with: self) { owner, tickets in
                owner.output.salesTickets.accept(tickets)
                owner.output.isLoading.accept(false)
                completion()
            }
            .disposed(by: self.disposeBag)
    }
}
