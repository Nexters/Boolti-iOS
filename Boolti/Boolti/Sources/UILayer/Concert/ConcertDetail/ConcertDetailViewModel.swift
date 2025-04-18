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
    case posterExpand(posters: [ConcertDetailEntity.Poster])
    case contentExpand(content: String)
    case ticketSelection(concertId: Int, type: TicketingType)
}

final class ConcertDetailViewModel {
    
    // MARK: Properties
    
    
    private let disposeBag = DisposeBag()
    private let concertRepository: ConcertRepositoryType
    
    struct Input {
        let didTicketingButtonTap = PublishRelay<TicketingType>()
        let didPosterViewTap = PublishRelay<Void>()
        let didExpandButtonTap = PublishRelay<Void>()
    }
    
    struct Output {
        let navigate = PublishRelay<ConcertDetailDestination>()
        let concertDetail = BehaviorRelay<ConcertDetailEntity?>(value: nil)
        var teamListEntities = BehaviorRelay<[ConcertCastTeamListEntity]?>(value: nil)

        let buttonState = BehaviorRelay<ConcertTicketingState>(value: .endSale)
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

extension ConcertDetailViewModel {
    
    private func bindInputs() {
        self.input.didExpandButtonTap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                guard let notice = owner.output.concertDetail.value?.notice else { return }
                owner.output.navigate.accept(.contentExpand(content: notice))
            }
            .disposed(by: self.disposeBag)
        
        self.input.didPosterViewTap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                guard let posters = owner.output.concertDetail.value?.posters else { return }
                owner.output.navigate.accept(.posterExpand(posters: posters))
            }
            .disposed(by: self.disposeBag)
        
        self.input.didTicketingButtonTap
            .asDriver(onErrorJustReturn: .ticketing)
            .drive(with: self) { owner, type in
                if UserDefaults.accessToken.isEmpty {
                    owner.output.navigate.accept(.login)
                } else {
                    guard let concertId = owner.output.concertDetail.value?.id else { return }
                    owner.output.navigate.accept(.ticketSelection(concertId: concertId, type: type))
                }
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension ConcertDetailViewModel {
 
    func fetchConcertDetail() {
        self.concertRepository.concertDetail(concertId: self.concertId)
            .asObservable()
            .bind(with: self, onNext: { owner, entity in
                owner.output.buttonState.accept(entity.ticketingState)
                owner.output.concertDetail.accept(entity)
            })
            .disposed(by: self.disposeBag)
    }

    func fetchCastTeamList() {
        self.concertRepository.castTeamList(concertId: self.concertId)
            .asObservable()
            .bind(to: self.output.teamListEntities)
            .disposed(by: self.disposeBag)
    }

}
