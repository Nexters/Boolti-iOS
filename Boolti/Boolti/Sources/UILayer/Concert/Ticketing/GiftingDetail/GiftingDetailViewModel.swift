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
    
    struct Input {
        let isAllAgreeButtonSelected = BehaviorRelay<Bool>(value: false)
    }
    
    let input: Input
    
    // MARK: Initailizer
    
    init() {
        self.input = Input()
    }

}
