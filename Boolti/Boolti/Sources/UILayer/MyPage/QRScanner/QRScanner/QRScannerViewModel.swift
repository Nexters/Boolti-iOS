//
//  QRScannerViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import Foundation

import RxSwift

final class QRScannerViewModel {
    
    // MARK: Properties
    
    struct Input {
        let detectQR = PublishSubject<Void>()
    }
    
    struct Output {
    }
    
    let input: Input
    let output: Output
    
    let concertName: String
    
    // MARK: Init
    
    init(concertName: String) {
        self.input = Input()
        self.output = Output()
        
//        self.concertName = concertName
        self.concertName = "2024 TOGETHER LUCKY Club"
    }
}

// MARK: - Network

extension QRScannerViewModel {
    
}
