//
//  GiftingRepository.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/21/24.
//

import Foundation

import RxSwift

protocol GiftingRepositoryType {
    var networkService: NetworkProviderType { get }
    func savePaymentInfo(concertId: Int,
                         selectedTicket: SelectedTicketEntity) -> Single<SavePaymentInfoResponseDTO>
}

final class GiftingRepository: GiftingRepositoryType {
    
    let networkService: NetworkProviderType
    
    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
    
    func savePaymentInfo(concertId: Int,
                         selectedTicket: SelectedTicketEntity) -> Single<SavePaymentInfoResponseDTO> {
        let savePaymentInfoRequestDTO = SavePaymentInfoRequestDTO(showId: concertId,
                                                                  salesTicketTypeId: selectedTicket.id,
                                                                  ticketCount: selectedTicket.count)
        
        let api = TicketingAPI.savePaymentInfo(requestDTO: savePaymentInfoRequestDTO)
        
        return self.networkService.request(api)
            .map(SavePaymentInfoResponseDTO.self)
    }
    
}
