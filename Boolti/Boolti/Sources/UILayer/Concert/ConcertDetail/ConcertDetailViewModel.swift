//
//  ConcertDetailViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import Foundation

import RxRelay
import RxSwift

final class ConcertDetailViewModel {
    
    // MARK: Properties
    
    enum ConcertTicketingState: String {
        case onSale = "예매하기"
        case beforeSale = "예매 시작 D-"
        case endSale = "예매 마감"
        case endConcert = "공연 종료"
    }
    
    private let disposeBag = DisposeBag()
    private let concertAPIService: ConcertAPIServiceType
    
    struct Output {
        let concertDetail: BehaviorRelay<ConcertDetailEntity>
        let buttonState = BehaviorRelay<ConcertTicketingState>(value: .onSale)
    }
    
    let output: Output
    
    // MARK: Init
    
    // TODO: DIContainer에서 concertId 주입받기
    init(concertAPIService: ConcertAPIService) {
        self.concertAPIService = concertAPIService
        self.output = Output(concertDetail: .init(value: .init()))
        
        self.bindOutputs()
        self.fetchConcertDetail(concertId: 1)
    }
}

// MARK: - Methods

extension ConcertDetailViewModel {
    
    private func bindOutputs() {
        self.output.concertDetail
            .bind(with: self, onNext: { owner, concert in
                var state: ConcertTicketingState = .onSale
                
                if Date().compare(concert.salesStartTime) == .orderedAscending {
                    state = .beforeSale
                }
                else if Date().compare(concert.salesEndTime) == .orderedAscending {
                    state = .onSale
                }
                else if Date().compare(concert.date) == .orderedAscending {
                    state = .endSale
                }
                else {
                    state = .endConcert
                }
                
                owner.output.buttonState.accept(state)
            })
            .disposed(by: self.disposeBag)
    }

    private func fetchConcertDetail(concertId: Int) {
        self.concertAPIService.concertDetail(concertId: concertId).asObservable()
            .bind(to: self.output.concertDetail)
            .disposed(by: self.disposeBag)
    }

}
