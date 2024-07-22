//
//  GiftingConfirmViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/21/24.
//

import Foundation

import RxSwift
import RxRelay

final class GiftingConfirmViewModel {
    
    // MARK: Properties
    
    private let giftingRepository: GiftingRepositoryType
    private let disposeBag = DisposeBag()
    
    struct Input {
        let didPayButtonTap = PublishRelay<Void>()
    }

    struct Output {
        let navigateToTossPayments = PublishRelay<Void>()
        let navigateToCompletion = PublishRelay<Void>()
        let didFreeOrderPaymentFailed = PublishRelay<Void>()
    }

    var input: Input
    var output: Output
    
    var giftingEntity: GiftingEntity

    init(giftingRepository: GiftingRepositoryType,
         giftingEntity: GiftingEntity) {
        self.giftingRepository = giftingRepository
        self.input = Input()
        self.output = Output()
        self.giftingEntity = giftingEntity
        
        self.bindInputs()
        
    }
}

// MARK: - Methods

extension GiftingConfirmViewModel {
    
    private func bindInputs() {
        self.input.didPayButtonTap
            .bind(with: self) { owner, _ in
                if owner.giftingEntity.selectedTicket.price == 0 {
//                    owner.freeSalesTicketing()
                } else {
                    owner.savePaymentInfo()
                }
            }
            .disposed(by: self.disposeBag)
    }

}

// MARK: - Network

extension GiftingConfirmViewModel {
    
    private func savePaymentInfo() {
        self.giftingRepository.savePaymentInfo(concertId: self.giftingEntity.concert.id,
                                                 selectedTicket: self.giftingEntity.selectedTicket)
        .do { self.giftingEntity.orderId = $0.orderId }
        .subscribe(with: self) { owner, response in
            owner.output.navigateToTossPayments.accept(())
        }
        .disposed(by: self.disposeBag)
    }
    
}
