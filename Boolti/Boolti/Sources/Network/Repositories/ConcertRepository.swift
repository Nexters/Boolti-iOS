//
//  ConcertRepository.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import Foundation

import RxSwift

protocol ConcertRepositoryType {
    var networkService: NetworkProviderType { get }
    func concertList(concertName: String?) -> Single<[ConcertEntity]>
    func concertDetail(concertId: Int) -> Single<ConcertDetailEntity>
    func salesTicket(concertId: Int) -> Single<[SelectedTicketEntity]>
}

final class ConcertRepository: ConcertRepositoryType {
    
    let networkService: NetworkProviderType
    
    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
    
    func concertList(concertName: String?) -> Single<[ConcertEntity]> {
        let concertListRequestDTO = ConcertListRequestDTO(nameLike: concertName)
        let api = ConcertAPI.list(requesDTO: concertListRequestDTO)
        
        return networkService.request(api)
            .map(ConcertListResponseDTO.self)
            .map { $0.convertToConcertEntities() }
    }
    
    func concertDetail(concertId: Int) -> Single<ConcertDetailEntity> {
        let concertDetailRequestDTO = ConcertDetailRequestDTO(id: concertId)
        let api = ConcertAPI.detail(requestDTO: concertDetailRequestDTO)
        
        return networkService.request(api)
            .map(ConcertDetailResponseDTO.self)
            .map { $0.convertToConcertDetailEntity() }
    }
    
    func salesTicket(concertId: Int) -> Single<[SelectedTicketEntity]> {
        let salesTicketRequestDTO = SalesTicketRequestDTO(showId: concertId)
        let api = TicketingAPI.salesTicket(requestDTO: salesTicketRequestDTO)
        
        return networkService.request(api)
            .map(SalesTicketResponseDTO.self)
            .map { $0.convertToSalesTicketEntities() }
    }

}
