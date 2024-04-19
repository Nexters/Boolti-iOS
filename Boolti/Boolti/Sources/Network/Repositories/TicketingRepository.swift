//
//  TicketingRepository.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/19/24.
//

import Foundation

import RxSwift

protocol TicketingRepositoryType {
    var networkService: NetworkProviderType { get }
    func salesTicketing(selectedTicket: SelectedTicketEntity,
                        ticketHolderName: String,
                        ticketHolderPhoneNumber: String,
                        depositorName: String,
                        depositorPhoneNumber: String) -> Single<TicketingResponseDTO>
    func checkInvitationCode(concertId: Int,
                             ticketId: Int,
                             invitationCode: String) -> Single<InvitationCodeStateEntity>
    func invitationTicketing(selectedTicket: SelectedTicketEntity,
                             ticketHolderName: String,
                             ticketHolderPhoneNumber: String,
                             invitationCode: String) -> Single<TicketingResponseDTO>
}

final class TicketingRepository: TicketingRepositoryType {
    
    let networkService: NetworkProviderType
    
    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
    
    func salesTicketing(selectedTicket: SelectedTicketEntity,
                        ticketHolderName: String,
                        ticketHolderPhoneNumber: String,
                        depositorName: String,
                        depositorPhoneNumber: String) -> Single<TicketingResponseDTO> {
        let salesTicketingRequestDTO = SalesTicketingRequestDTO(userId: UserDefaults.userId,
                                                                showId: selectedTicket.concertId,
                                                                salesTicketTypeId: selectedTicket.id,
                                                                ticketCount: selectedTicket.count,
                                                                reservationName: ticketHolderName,
                                                                reservationPhoneNumber: ticketHolderPhoneNumber,
                                                                depositorName: depositorName,
                                                                depositorPhoneNumber: depositorPhoneNumber,
                                                                paymentAmount: selectedTicket.count * selectedTicket.price,
                                                                means: "ACCOUNT_TRANSFER")
        let api = TicketingAPI.salesTicketing(requestDTO: salesTicketingRequestDTO)
        
        return networkService.request(api)
            .map(TicketingResponseDTO.self)
    }
    
    func checkInvitationCode(concertId: Int, ticketId: Int, invitationCode: String) -> Single<InvitationCodeStateEntity> {
        let checkInvitationCodeRequestDTO = CheckInvitationCodeRequestDTO(showId: concertId,
                                                                          salesTicketTypeId: ticketId,
                                                                          inviteCode: invitationCode)
        let api = TicketingAPI.checkInvitationCode(requestDTO: checkInvitationCodeRequestDTO)
        
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
        
        let api = TicketingAPI.invitationTicketing(requestDTO: invitationTicketingRequestDTO)
        
        return networkService.request(api)
            .map(TicketingResponseDTO.self)
    }
    
}
