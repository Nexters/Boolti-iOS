//
//  ConcertRepository.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import Foundation

import RxSwift

final class ConcertRepository: ConcertRepositoryType {
    
    let networkService: NetworkProviderType
    private let disposeBag = DisposeBag()
    
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
    
    func salesTicket(concertId: Int) -> Single<[SalesTicketEntity]> {
        let salesTicketRequestDTO = SalesTicketRequestDTO(showId: concertId)
        let api = ConcertAPI.salesTicket(requestDTO: salesTicketRequestDTO)
        
        return networkService.request(api)
            .map(SalesTicketResponseDTO.self)
            .map { $0.convertToSalesTicketEntities() }
    }
    
    func salesTicketing(concertId: Int,
                        selectedTicket: SalesTicketEntity,
                        ticketHolderName: String,
                        ticketHolderPhoneNumber: String,
                        depositorName: String,
                        depositorPhoneNumber: String) -> Single<SalesTicketingResponseDTO> {
        let salesTicketingRequestDTO = SalesTicketingRequestDTO(userId: UserDefaults.userId,
                                                                showId: concertId,
                                                                salesTicketTypeId: selectedTicket.id,
                                                                ticketCount: 1,
                                                                reservationName: ticketHolderName,
                                                                reservationPhoneNumber: ticketHolderPhoneNumber,
                                                                depositorName: depositorName,
                                                                depositorPhoneNumber: depositorPhoneNumber,
                                                                paymentAmount: selectedTicket.price,
                                                                means: "ACCOUNT_TRANSFER")
        let api = ConcertAPI.salesTicketing(requestDTO: salesTicketingRequestDTO)
        
        return networkService.request(api)
            .map(SalesTicketingResponseDTO.self)
    }
}
