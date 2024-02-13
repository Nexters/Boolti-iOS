//
//  QRScannerListViewModel.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

import RxSwift
import RxRelay

final class QRScannerListViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    struct Output {
        let qrScanners = PublishRelay<[QRScannerEntity]>()
    }
    
    let output: Output
    
    // MARK: Init
    
    init() {
        self.output = Output()
    }
}

// MARK: - Network

extension QRScannerListViewModel {
    
}
