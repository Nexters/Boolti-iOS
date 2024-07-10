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
        let selectedImageIndex = BehaviorRelay<Int?>(value: nil)
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
        let cardImages = BehaviorRelay<[GiftCardImageEntity]>(value: [.init(id: 0, path: "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2F736x%2F84%2Fd7%2F76%2F84d776850719e7f5dcd8d6014d7f5445--lego-birthday-birthday-cards.jpg&type=a340", thumbnailPath: "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2F736x%2F84%2Fd7%2F76%2F84d776850719e7f5dcd8d6014d7f5445--lego-birthday-birthday-cards.jpg&type=a340"), .init(id: 1, path: "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F7c%2Ff3%2F18%2F7cf318aaea37cc8e0d5467e2d35ea02c.jpg&type=a340", thumbnailPath: "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F7c%2Ff3%2F18%2F7cf318aaea37cc8e0d5467e2d35ea02c.jpg&type=a340"), .init(id: 2, path: "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F01%2Fc2%2Fdd%2F01c2dd030a5103d3d5f43befd267ccc9.jpg&type=a340", thumbnailPath: "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F01%2Fc2%2Fdd%2F01c2dd030a5103d3d5f43befd267ccc9.jpg&type=a340"), .init(id: 3, path: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b", thumbnailPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b"), .init(id: 4, path: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b", thumbnailPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b"), .init(id: 5, path: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b", thumbnailPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b"), .init(id: 6, path: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b", thumbnailPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b"), .init(id: 7, path: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b", thumbnailPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b"), .init(id: 8, path: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b", thumbnailPath: "https://yobwhuwlrftg22440152.gcdn.ntruss.com/show-images/005c8303-c210-48ca-a7de-adc9bf8da57b")])
        let selectedCardImageURL = PublishRelay<String>()
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
        
        self.input.selectedImageIndex
            .bind(with: self) { owner, index in
                guard let index = index else { return }
                let selectedImage = owner.output.cardImages.value[index].path
                owner.output.selectedCardImageURL.accept(selectedImage)
            }
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
