//
//  ConcertAPIService.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import RxSwift

final class ConcertAPIService: ConcertAPIServiceType {
    
    let networkService: NetworkProviderType
    private let disposeBag = DisposeBag()
    
    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
    
    func concertDetail(concertId: Int) -> Single<ConcertDetailEntity> {
        let concertDetailRequestDTO = ConcertDetailRequestDTO(id: concertId)
        let api = ConcertAPI.detail(requestDTO: concertDetailRequestDTO)
        
        return networkService.request(api)
            .map(ConcertDetailResponseDTO.self)
            .map { $0.convertToConcertDetailEntity() }
    }
}
