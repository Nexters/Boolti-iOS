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
    
    func salesTicket(concertId: Int) -> Single<[SelectedTicketEntity]> {
        let salesTicketRequestDTO = SalesTicketRequestDTO(showId: concertId)
        let api = ConcertAPI.salesTicket(requestDTO: salesTicketRequestDTO)
        
        return networkService.request(api)
            .map(SalesTicketResponseDTO.self)
            .map { $0.convertToSalesTicketEntities() }
    }
    
    func salesTicketing(selectedTicket: SelectedTicketEntity,
                        ticketHolderName: String,
                        ticketHolderPhoneNumber: String,
                        depositorName: String,
                        depositorPhoneNumber: String) -> Single<TicketingResponseDTO> {
        let salesTicketingRequestDTO = SalesTicketingRequestDTO(userId: UserDefaults.userId,
                                                                showId: selectedTicket.concertId,
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
            .map(TicketingResponseDTO.self)
    }
    
    func checkInvitationCode(concertId: Int, ticketId: Int, invitationCode: String) -> Single<InvitationCodeStateEntity> {
        let checkInvitationCodeRequestDTO = CheckInvitationCodeRequestDTO(showId: concertId,
                                                                          salesTicketTypeId: ticketId,
                                                                          inviteCode: invitationCode)
        let api = ConcertAPI.checkInvitationCode(requestDTO: checkInvitationCodeRequestDTO)
        
        return self.networkService.request(api)
            .map(CheckInvitationCodeResponseDTO.self)
            .map { $0.convertToInvitationCodeEntity() }
    }
    
    func invitationTicketing(selectedTicket: SelectedTicketEntity,
                             ticketHolderName: String,
                             ticketHolderPhoneNumber: String,
                             invitationCode: String) -> Single<TicketingResponseDTO> {
        let invitationTicketingRequestDTO = InvitationTicketingRequestDTO(userId: UserDefaults.userId,
                                                                   showId: selectedTicket.concertId,
                                                                   salesTicketTypeId: selectedTicket.id,
                                                                   reservationName: ticketHolderName,
                                                                   reservationPhoneNumber: ticketHolderPhoneNumber,
                                                                   inviteCode: invitationCode)
        
        let api = ConcertAPI.invitationTicketing(requestDTO: invitationTicketingRequestDTO)
        
        return networkService.request(api)
            .map(TicketingResponseDTO.self)
    }
    
}
