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
        
    }
}

// MARK: - Methods

extension GiftingConfirmViewModel {

}
