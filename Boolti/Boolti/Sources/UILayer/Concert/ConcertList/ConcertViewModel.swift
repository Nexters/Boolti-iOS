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
    private let appRepository: AppRepositoryType
    
    enum GiftType {
        case send
        case receive
    }
    
    struct Input {
        let checkGift = PublishSubject<String>()
        let didRegisterGiftButtonTap = PublishRelay<Void>()
    }
    
    struct Output {
        let didConcertFetch = PublishRelay<Void>()
        var showBanner: Bool = false
        var topConcerts: [ConcertEntity] = []
        var bottomConcerts: [ConcertEntity] = []
        let showRegisterGiftPopUp = PublishRelay<GiftType>()
        let didRegisterGift = PublishRelay<Bool>()
        let showEventPopup = PublishRelay<PopupEntity>()
    }
    
    let input: Input
    var output: Output
    
    var giftUuid: String?
    
    // MARK: Init
    
    init(concertRepository: ConcertRepository) {
        self.input = Input()
        self.output = Output()
        self.concertRepository = concertRepository
        self.giftingRepository = GiftingRepository(networkService: self.concertRepository.networkService)
        self.appRepository = AppRepository(networkService: self.concertRepository.networkService)
        
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
            .subscribe(with: self) { owner, concerts in
                owner.output.topConcerts = Array(concerts.prefix(4))
                owner.output.bottomConcerts = Array(concerts.dropFirst(4))
                owner.output.showBanner = true
                owner.output.didConcertFetch.accept(())
            }
            .disposed(by: self.disposeBag)
    }
    
    func checkGift(giftUuid: String) {
        self.giftUuid = giftUuid
        
        self.giftingRepository.giftInfo(with: giftUuid)
            .subscribe(with: self) { owner, userId in
                if UserDefaults.userId == userId {
                    self.output.showRegisterGiftPopUp.accept(.send)
                } else {
                    self.output.showRegisterGiftPopUp.accept(.receive)
                }
            }
            .disposed(by: self.disposeBag)
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
    
    func checkAdminPopup() {
        self.appRepository.popup()
            .subscribe(with: self) { owner, popupData in
                switch popupData.type {
                case .event:
                    if let stopShowDate = UserDefaults.eventPopupStopShowDate {
                        if stopShowDate >= popupData.startDate && stopShowDate <= popupData.endDate {
                            if stopShowDate.getBetweenDay(to: Date()) > 0 {
                                owner.output.showEventPopup.accept(popupData)
                            }
                        }
                    } else {
                        owner.output.showEventPopup.accept(popupData)
                    }
                case .notice:
                    print()
                    // notice popup 띄우기
                }
            }
            .disposed(by: self.disposeBag)
    }
    
}
