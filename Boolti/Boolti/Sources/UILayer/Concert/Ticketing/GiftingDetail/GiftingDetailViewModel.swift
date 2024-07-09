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
        let message = BehaviorRelay<String>(value: "")
        let selectedImageIndex = BehaviorRelay<IndexPath>(value: .init(index: 0))
        let receiverName = BehaviorRelay<String>(value: "")
        let receiverPhoneNumber = BehaviorRelay<String>(value: "")
        let senderName = BehaviorRelay<String>(value: "")
        let senderPhoneNumber = BehaviorRelay<String>(value: "")
        let isAllAgreeButtonSelected = BehaviorRelay<Bool>(value: false)
        let didPayButtonTap = PublishSubject<Void>()
    }
    
    struct Output {
        let concertDetail = BehaviorRelay<ConcertDetailEntity?>(value: nil)
        let isPaybuttonEnable = PublishSubject<Bool>()
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
        
        self.bindInputs()
        self.fetchConcertDetail()
    }
    
}

// MARK: - Methods

extension GiftingDetailViewModel {
    
    private func bindInputs() {
        Observable.combineLatest(self.checkInputViewTextFieldFilled(),
                                 self.input.isAllAgreeButtonSelected)
        .map { $0 && $1 }
        .distinctUntilChanged()
        .bind(to: self.output.isPaybuttonEnable)
        .disposed(by: self.disposeBag)
    }
    
    private func checkInputViewTextFieldFilled() -> Observable<Bool> {
        return Observable.combineLatest(self.input.receiverName,
                                        self.input.receiverPhoneNumber,
                                        self.input.senderName,
                                        self.input.senderPhoneNumber)
        .map {
            return !$0.trimmingCharacters(in: .whitespaces).isEmpty &&
            !$1.trimmingCharacters(in: .whitespaces).isEmpty &&
            !$2.trimmingCharacters(in: .whitespaces).isEmpty &&
            !$3.trimmingCharacters(in: .whitespaces).isEmpty
        }
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
