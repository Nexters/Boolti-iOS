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
    private let giftingRepository: GiftingRepositoryType
    
    struct Input {
        let message = BehaviorRelay<String>(value: "")
        let selectedImageIndex = PublishRelay<Int>()
        let receiverName = BehaviorRelay<String>(value: "")
        let receiverPhoneNumber = BehaviorRelay<String>(value: "")
        let senderName = BehaviorRelay<String>(value: "")
        let senderPhoneNumber = BehaviorRelay<String>(value: "")
        let isAllAgreeButtonSelected = BehaviorRelay<Bool>(value: false)
        let didPayButtonTap = PublishRelay<Void>()
    }
    
    struct Output {
        let concertDetail = BehaviorRelay<ConcertDetailEntity?>(value: nil)
        let isPaybuttonEnable = PublishRelay<Bool>()
        let cardImages = BehaviorSubject<[GiftCardImageEntity]>(value: [])
        let selectedCardImageEntity = BehaviorRelay<GiftCardImageEntity?>(value: nil)
        let navigateToConfirm = PublishRelay<Void>()
        var giftingEntity: GiftingEntity?
    }
    
    let input: Input
    var output: Output
    
    let selectedTicket: SelectedTicketEntity
    
    // MARK: Initailizer
    
    init(concertRepository: ConcertRepositoryType,
         giftingRepository: GiftingRepositoryType,
         selectedTicket: SelectedTicketEntity) {
        self.concertRepository = concertRepository
        self.giftingRepository = giftingRepository
        self.selectedTicket = selectedTicket
        self.input = Input()
        self.output = Output()
        
        self.bindInputs()
        self.fetchConcertDetail()
        self.fetchCardImages()
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
                do {
                    let imageUrls = try owner.output.cardImages.value()
                    owner.output.selectedCardImageEntity.accept(imageUrls[index])
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            .disposed(by: self.disposeBag)
        
        self.input.didPayButtonTap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.setGiftingData()
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setGiftingData() {
        guard let concertDetail = self.output.concertDetail.value else { return }
        
        let receiverData = GiftingEntity.UserInfo(name: self.input.receiverName.value,
                                                  phoneNumber: self.input.receiverPhoneNumber.value)
        let senderData = GiftingEntity.UserInfo(name: self.input.senderName.value,
                                                  phoneNumber: self.input.senderPhoneNumber.value)
        
        guard let selectedImage = self.output.selectedCardImageEntity.value else { return }
        let giftingEntity = GiftingEntity(concert: concertDetail,
                                          sender: senderData,
                                          receiver: receiverData,
                                          selectedTicket: self.selectedTicket,
                                          message: self.input.message.value,
                                          giftImgId: selectedImage.id)
        
        self.output.giftingEntity = giftingEntity
        self.output.navigateToConfirm.accept(())
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
            .subscribe(with: self) { owner, entity in
                owner.output.concertDetail.accept(entity)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func fetchCardImages() {
        self.giftingRepository.giftCardImages()
            .subscribe(with: self) { owner, images in
                owner.output.cardImages.onNext(images)
                
                if !images.isEmpty {
                    owner.input.selectedImageIndex.accept(0)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
}
