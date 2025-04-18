//
//  QRRepository.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import Foundation

import RxSwift

protocol QRRepositoryType: RepositoryType {
    
    var networkService: NetworkProviderType { get }
    func scannerList() -> Single<[QRScannerEntity]>
    func qrScan(concertId: Int, entranceCode: String) -> Single<Bool>
}

final class QRRepository: QRRepositoryType {
    
    let networkService: NetworkProviderType
    
    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
    
    func scannerList() -> Single<[QRScannerEntity]> {
        let api = QRAPI.scannerlist
        
        return networkService.request(api)
            .map(QRScannerListResponseDTO.self)
            .map { $0.convertToQRScannerEntities() }
    }
    
    func qrScan(concertId: Int, entranceCode: String) -> Single<Bool> {
        let qrScanRequestDTO = QRScanRequestDTO(showId: concertId, entryCode: entranceCode)
        let api = QRAPI.qrScan(requestDTO: qrScanRequestDTO)
        
        return networkService.request(api)
            .map(Bool.self)
    }
}
