//
//  ConcertAPIServiceType.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import RxSwift

protocol ConcertAPIServiceType {

    var networkService: NetworkProviderType { get }
    func concertDetail(concertId: Int) -> Single<ConcertDetailEntity>
}
