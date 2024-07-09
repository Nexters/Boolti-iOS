//
//  GiftingDetailViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 6/23/24.
//

import Foundation

import RxSwift
import RxRelay

final class GiftingDetailViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let concertRepository: ConcertRepositoryType
    
    struct Input {
        let isAllAgreeButtonSelected = BehaviorRelay<Bool>(value: false)
    }
    
    struct Output {
        let concertDetail = BehaviorRelay<ConcertDetailEntity?>(value: nil)
    }
    
    let input: Input
    let output: Output
    
    let selectedTicket: SelectedTicketEntity
    
    // MARK: Initailizer
    
    init(concertRepository: ConcertRepositoryType,
         selectedTicket: SelectedTicketEntity) {
        self.concertRepository = concertRepository
        self.selectedTicket = selectedTicket
        self.input = Input()
        self.output = Output()
        
        self.fetchConcertDetail()
    }

}

// MARK: - Network

extension GiftingDetailViewModel {
    
    private func fetchConcertDetail() {
        self.concertRepository.concertDetail(concertId: self.selectedTicket.concertId)
            .asObservable()
            .bind(to: self.output.concertDetail)
            .disposed(by: self.disposeBag)
    }
    
}
