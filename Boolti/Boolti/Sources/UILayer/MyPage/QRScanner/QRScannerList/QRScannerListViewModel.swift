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
    private let qrRepository: QRRepositoryType
    
    struct Output {
        let qrScanners = PublishRelay<[QRScannerEntity]>()
    }
    
    let output: Output
    
    // MARK: Init
    
    init(qrRepository: QRRepositoryType) {
        self.output = Output()
        self.qrRepository = qrRepository
    }
}

// MARK: - Network

extension QRScannerListViewModel {
    
    func fetchQRList() {
        self.qrRepository.scannerList()
            .asObservable()
            .bind(to: self.output.qrScanners)
            .disposed(by: self.disposeBag)
    }
}
