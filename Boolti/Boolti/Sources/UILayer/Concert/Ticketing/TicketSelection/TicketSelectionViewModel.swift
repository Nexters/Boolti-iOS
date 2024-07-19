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
        let didDeleteButtonTap = PublishSubject<Void>()
        let selectedTicket = BehaviorRelay<SelectedTicketEntity?>(value: nil)
        let ticketCount = BehaviorRelay<Int>(value: 1)
        let didTicketingButtonTap = PublishSubject<Void>()
    }

    struct Output {
        let isLoading = PublishRelay<Bool>()
        let salesTickets = BehaviorRelay<[SelectedTicketEntity]>(value: [])
        let showTicketTypeView = PublishSubject<Void>()
        let didSalesTicketFetched = PublishSubject<Void>()
        let navigateTicketingDetail = PublishSubject<SelectedTicketEntity>()
    }

    let input: Input
    var output: Output
    
    private let concertId: Int
    let type: TicketingType
    
    // MARK: Init

    init(concertRepository: ConcertRepository,
         concertId: Int,
         type: TicketingType) {
        self.concertRepository = concertRepository
        self.concertId = concertId
        self.type = type
        
        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }
}

// MARK: - Methods

extension TicketSelectionViewModel {
    
    private func bindInputs() {
        self.input.didDeleteButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.input.selectedTicket.accept(nil)
                owner.input.ticketCount.accept(1)
            })
            .disposed(by: self.disposeBag)
        
        self.input.selectedTicket
            .asDriver()
            .drive(with: self, onNext: { owner, ticket in
                if ticket == nil {
                    owner.output.showTicketTypeView.onNext(())
                }
            })
            .disposed(by: self.disposeBag)
        
        self.input.didTicketingButtonTap
            .bind(with: self) { owner, _ in
                guard var selectedTicket = owner.input.selectedTicket.value else { return }
                selectedTicket.count = owner.input.ticketCount.value
                
                owner.output.navigateTicketingDetail.onNext(selectedTicket)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension TicketSelectionViewModel {
    
    func fetchSalesTicket() {
        self.output.isLoading.accept(true)
        self.concertRepository.salesTicket(concertId: self.concertId)
            .map({ [weak self] tickets in
                if self?.type == .gifting {
                    return tickets.filter { $0.ticketType == .sale }
                } else {
                    return tickets
                }
            })
            .subscribe(with: self) { owner, tickets in
                owner.output.salesTickets.accept(tickets)
                owner.output.isLoading.accept(false)
                owner.output.didSalesTicketFetched.onNext(())
            }
            .disposed(by: self.disposeBag)
    }
}
