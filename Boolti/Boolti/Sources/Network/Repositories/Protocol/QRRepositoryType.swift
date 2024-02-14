//
//  QRRepositoryType.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import RxSwift

protocol QRRepositoryType {
    
    var networkService: NetworkProviderType { get }
    func scannerList() -> Single<[QRScannerEntity]>
    func qrScan(concertId: Int, entranceCode: String) -> Single<Bool>
}
