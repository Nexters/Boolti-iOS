//
//  ConcertContentExpandViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/6/24.
//

import Foundation

import RxRelay
import RxSwift

final class ConcertContentExpandViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    struct Output {
        let content = BehaviorRelay<String>(value: "")
    }
    
    let output: Output
    
    // MARK: Init
    
    init(content: String) {
        self.output = Output()
        
        self.output.content.accept(content)
    }
}
