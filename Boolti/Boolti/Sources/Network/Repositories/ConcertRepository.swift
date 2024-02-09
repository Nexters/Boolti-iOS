//
//  ConcertRepository.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import RxSwift

final class ConcertRepository: ConcertRepositoryType {
    
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
    
    func salesTicket(concertId: Int) -> Single<[SalesTicketEntity]> {
        let salesTicketRequestDTO = SalesTicketRequestDTO(showId: concertId)
        let api = ConcertAPI.salesTicket(requestDTO: salesTicketRequestDTO)
        
        return networkService.request(api)
            .map(SalesTicketResponseDTO.self)
            .map { $0.convertToSalesTicketEntities() }
    }
}
