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
    private let giftingRepository: GiftingRepositoryType
    
    enum GiftType {
        case send
        case receive
    }
    
    struct Input {
        let checkGift = PublishSubject<String>()
        let didRegisterGiftButtonTap = PublishRelay<Void>()
    }
    
    struct Output {
        let concerts = BehaviorRelay<[ConcertEntity]>(value: [])
        let showRegisterGiftPopUp = PublishRelay<GiftType>()
        let didRegisterGift = PublishRelay<Bool>()
    }
    
    let input: Input
    let output: Output
    
    var giftUuid: String?
    
    // MARK: Init
    
    init(concertRepository: ConcertRepository) {
        self.input = Input()
        self.output = Output()
        self.concertRepository = concertRepository
        self.giftingRepository = GiftingRepository(networkService: self.concertRepository.networkService)
        
        self.bindInputs()
    }
}

// MARK: - Methods

extension ConcertListViewModel {
    
    private func bindInputs() {
        self.input.checkGift
            .subscribe(with: self) { owner, giftUuid in
                owner.checkGift(giftUuid: giftUuid)
            }
            .disposed(by: self.disposeBag)
        
        self.input.didRegisterGiftButtonTap
            .subscribe(with: self, onNext: { owner, _ in
                guard let giftUuid = owner.giftUuid else { return }
                owner.registerGift(giftUuid: giftUuid)
            })
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
    
    func checkGift(giftUuid: String) {
        self.giftUuid = giftUuid
        
        // TODO: - 서버 확인 후 자신의 선물인지 확인
        self.output.showRegisterGiftPopUp.accept(.receive)
        self.output.showRegisterGiftPopUp.accept(.send)
    }
    
    private func registerGift(giftUuid: String) {
        self.giftingRepository.registerGift(giftUuid: giftUuid)
            .subscribe(with: self, onSuccess: { owner, _ in
                owner.output.didRegisterGift.accept(true)
            }, onFailure: { owner, _ in
                owner.output.didRegisterGift.accept(false)
            })
            .disposed(by: self.disposeBag)
    }
    
}
