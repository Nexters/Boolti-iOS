//
//  QRRepository.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import Foundation

import RxSwift

final class QRRepository: QRRepositoryType {
    
    let networkService: NetworkProviderType
    private let disposeBag = DisposeBag()
    
    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
    
    func scannerList() -> Single<[QRScannerEntity]> {
        let api = QRAPI.scannerlist
        
        return networkService.request(api)
            .map(QRScannerListResponseDTO.self)
            .map { $0.convertToQRScannerEntities() }
    }
}
