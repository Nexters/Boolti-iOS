//
//  ConcertListViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

import RxSwift
import RxRelay

final class ConcertListViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let concertRepository: ConcertRepositoryType
    private let ticketReservationRepository: TicketReservationRepository
    
    struct Output {
        let concerts = BehaviorRelay<[ConcertEntity]>(value: [])
        let checkingTicketCount = BehaviorRelay<Int>(value: -1)
    }
    
    let output: Output
    
    // MARK: Init
    
    init(concertRepository: ConcertRepository,
         ticketReservationRepository: TicketReservationRepository) {
        self.output = Output()
        self.concertRepository = concertRepository
        self.ticketReservationRepository = ticketReservationRepository
    }
}

// MARK: - Network

extension ConcertListViewModel {
    
    func fetchConcertList(concertName: String?) {
        self.concertRepository.concertList(concertName: concertName)
            .asObservable()
            .bind(to: self.output.concerts)
            .disposed(by: self.disposeBag)
    }

    func confirmCheckingTickets() {
        if UserDefaults.accessToken.isEmpty {
            self.output.checkingTicketCount.accept(-1)
        } else {
            self.fetchCheckingTickets()
        }
    }
    
    private func fetchCheckingTickets() {
        self.ticketReservationRepository.ticketReservations()
            .asObservable()
            .subscribe(with: self, onNext: { owner, ticketReservations in
//                let waitingForDepositReservations = ticketReservations.filter { $0.reservationStatus == .waitingForDeposit }
//                let count = waitingForDepositReservations.count > 0 ? 1 : 0
                let count = 0
                owner.output.checkingTicketCount.accept(count)
            })
            .disposed(by: self.disposeBag)
    }
}
