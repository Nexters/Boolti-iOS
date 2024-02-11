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
    
    struct Output {
        let concerts = BehaviorRelay<[ConcertEntity]>(value: [ConcertEntity(id: 0, name: "아아", dateTime: Date(), posterPath: "https://dudoong.com/_next/image?url=https%3A%2F%2Fasset.dudoong.com%2Fproduction%2Fevent%2F153%2F14cc2eca-7c83-43ca-8ae4-85a7569f298e.png&w=640&q=75"), ConcertEntity(id: 0, name: "아아아아아아ㅏ", dateTime: Date(), posterPath: "https://dudoong.com/_next/image?url=https%3A%2F%2Fasset.dudoong.com%2Fproduction%2Fevent%2F153%2F14cc2eca-7c83-43ca-8ae4-85a7569f298e.png&w=640&q=75"), ConcertEntity(id: 0, name: "아아\n어어어어", dateTime: Date(), posterPath: "https://dudoong.com/_next/image?url=https%3A%2F%2Fasset.dudoong.com%2Fproduction%2Fevent%2F153%2F14cc2eca-7c83-43ca-8ae4-85a7569f298e.png&w=640&q=75")])
    }
    
    let output: Output
    
    // MARK: Init
    
    init(concertRepository: ConcertRepository) {
        self.output = Output()
        self.concertRepository = concertRepository
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
