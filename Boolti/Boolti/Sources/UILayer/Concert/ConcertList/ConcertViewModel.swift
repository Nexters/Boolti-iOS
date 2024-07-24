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
    
    struct Input {
        let checkGift = PublishSubject<String>()
    }
    
    struct Output {
        let concerts = BehaviorRelay<[ConcertEntity]>(value: [])
        
        // 본인 선물인지에 따라 다르게 떠야함
        let showRegisterGiftPopUp = PublishRelay<Bool>()
    }
    
    let input: Input
    let output: Output
    
    // MARK: Init
    
    init(concertRepository: ConcertRepository) {
        self.input = Input()
        self.output = Output()
        self.concertRepository = concertRepository
        
        self.bindInputs()
    }
}

// MARK: - Methods

extension ConcertListViewModel {
    
    private func bindInputs() {
        self.input.checkGift
            .subscribe(with: self) { owner, giftUuid in
                print(giftUuid)
            }
            .disposed(by: self.disposeBag)
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

}
