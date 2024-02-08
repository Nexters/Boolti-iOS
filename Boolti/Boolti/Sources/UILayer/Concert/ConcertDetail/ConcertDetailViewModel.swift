//
//  ConcertDetailViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import Foundation

import RxRelay
import RxSwift

enum ConcertDetailDestination {
    case login
    case contentExpand(content: String)
    case ticketSelection(concertId: Int)
}

final class ConcertDetailViewModel {
    
    // MARK: Properties
    
    enum ConcertTicketingState: String {
        case onSale = "예매하기"
        case beforeSale = "예매 시작 D-"
        case endSale = "예매 마감"
        case endConcert = "공연 종료"
    }
    
    private let disposeBag = DisposeBag()
    private let concertRepository: ConcertRepositoryType
    
    struct Input {
        let didTicketingButtonTap = PublishRelay<Void>()
        let didExpandButtonTap = PublishRelay<Void>()
    }
    
    struct Output {
        let navigate = PublishRelay<ConcertDetailDestination>()
        let showLoginEnterView = BehaviorRelay<Bool>(value: false)
        let concertDetail = PublishRelay<ConcertDetailEntity>()
        var concertDetailEntity: ConcertDetailEntity?
        let buttonState = BehaviorRelay<ConcertTicketingState>(value: .endSale)
    }
    
    let input: Input
    var output: Output
    
    // MARK: Init
    
    // TODO: DIContainer에서 concertId 주입받기
    init(concertRepository: ConcertRepository) {
        self.concertRepository = concertRepository
        self.input = Input()
        self.output = Output()
        
        self.bindInputs()
        self.bindOutputs()
        self.fetchConcertDetail(concertId: 1)
    }
}

// MARK: - Methods

extension ConcertDetailViewModel {
    
    private func bindInputs() {
        self.input.didExpandButtonTap
            .bind(with: self) { owner, _ in
                owner.output.navigate.accept(.contentExpand(content: "담배 노노요"))
            }
            .disposed(by: self.disposeBag)
        
        self.input.didTicketingButtonTap
            .bind(with: self) { owner, _ in
                if UserDefaults.accessToken.isEmpty {
                    owner.output.showLoginEnterView.accept(true)
                } else {
                    owner.output.navigate.accept(.ticketSelection(concertId: 1))
                }
            }
            .disposed(by: self.disposeBag)
    }
    
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
}

// MARK: - Network

extension ConcertDetailViewModel {
 
    private func fetchConcertDetail(concertId: Int) {
        self.concertRepository.concertDetail(concertId: concertId).asObservable()
            .do { self.output.concertDetailEntity = $0 }
            .bind(to: self.output.concertDetail)
            .disposed(by: self.disposeBag)
    }

}
