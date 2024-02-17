//
//  ConcertDetailViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import UIKit

import RxRelay
import RxSwift

enum ConcertDetailDestination {
    case login
    case contentExpand(content: String)
    case ticketSelection(concertId: Int)
}

final class ConcertDetailViewModel {
    
    // MARK: Properties
    
    enum ConcertTicketingState {
        case onSale
        case beforeSale(startDate: Date)
        case endSale
        case endConcert
        case alreadyReserved
        
        var title: String {
            switch self {
            case .onSale: "예매하기"
            case .beforeSale(let startDate):
                "예매 시작 D-\(Date().getBetweenDay(to: startDate))"
            case .endSale: "예매 마감"
            case .endConcert: "공연 종료"
            case .alreadyReserved: "이미 예매한 공연"
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .beforeSale: .orange01
            case .onSale: .white00
            default: .grey50
            }
        }
        
        var isEnabled: Bool {
            switch self {
            case .onSale: true
            default: false
            }
        }
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
    
    let concertId: Int
    
    // MARK: Init
    
    init(concertRepository: ConcertRepository,
         concertId: Int) {
        self.concertRepository = concertRepository
        self.concertId = concertId
        self.input = Input()
        self.output = Output()
        
        self.bindInputs()
        self.bindOutputs()
    }
}

// MARK: - Methods

extension ConcertDetailViewModel {
    
    private func bindInputs() {
        self.input.didExpandButtonTap
            .bind(with: self) { owner, _ in
                guard let notice = owner.output.concertDetailEntity?.notice else { return }
                owner.output.navigate.accept(.contentExpand(content: notice))
            }
            .disposed(by: self.disposeBag)
        
        self.input.didTicketingButtonTap
            .bind(with: self) { owner, _ in
                if UserDefaults.accessToken.isEmpty {
                    owner.output.showLoginEnterView.accept(true)
                } else {
                    guard let concertId = owner.output.concertDetailEntity?.id else { return }
                    owner.output.navigate.accept(.ticketSelection(concertId: concertId))
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.output.concertDetail
            .bind(with: self, onNext: { owner, concert in
                if concert.reservationStatus {
                    owner.output.buttonState.accept(.alreadyReserved)
                    return
                }
                
                var state: ConcertTicketingState = .onSale
                
                if Date().compare(concert.salesStartTime) == .orderedAscending {
                    state = .beforeSale(startDate: concert.salesStartTime)
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
 
    func fetchConcertDetail() {
        self.concertRepository.concertDetail(concertId: self.concertId)
            .do { self.output.concertDetailEntity = $0 }
            .asObservable()
            .bind(to: self.output.concertDetail)
            .disposed(by: self.disposeBag)
    }

}
