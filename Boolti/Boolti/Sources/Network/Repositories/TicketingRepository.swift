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
    func checkInvitationCode(concertId: Int,
                             ticketId: Int,
                             invitationCode: String) -> Single<InvitationCodeStateEntity>
    func freeTicketing(selectedTicket: SelectedTicketEntity,
                       ticketHolderName: String,
                       ticketHolderPhoneNumber: String) -> Single<TicketingResponseDTO>
    func invitationTicketing(selectedTicket: SelectedTicketEntity,
                             ticketHolderName: String,
                             ticketHolderPhoneNumber: String,
                             invitationCode: String) -> Single<TicketingResponseDTO>
    func savePaymentInfo(concertId: Int,
                         selectedTicket: SelectedTicketEntity) -> Single<SavePaymentInfoResponseDTO>
    func orderPayment(paymentKey: String,
                      amount: Int,
                      ticketingEntity: TicketingEntity) -> Single<OrderPaymentResponseDTO>
}

final class TicketingRepository: TicketingRepositoryType {
    
    let networkService: NetworkProviderType
    
    init(networkService: NetworkProviderType) {
        self.networkService = networkService
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
    
    func freeTicketing(selectedTicket: SelectedTicketEntity,
                       ticketHolderName: String,
                       ticketHolderPhoneNumber: String) -> Single<TicketingResponseDTO> {
        let freeTicketingRequestDTO = FreeTicketingRequestDTO(userId: UserDefaults.userId,
                                                              showId: selectedTicket.concertId,
                                                              salesTicketTypeId: selectedTicket.id,
                                                              ticketCount: selectedTicket.count,
                                                              reservationName: ticketHolderName,
                                                              reservationPhoneNumber: ticketHolderPhoneNumber)
        
        let api = TicketingAPI.freeTicketing(requestDTO: freeTicketingRequestDTO)
        
        return networkService.request(api)
            .map(TicketingResponseDTO.self)
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
    
    func savePaymentInfo(concertId: Int,
                         selectedTicket: SelectedTicketEntity) -> Single<SavePaymentInfoResponseDTO> {
        let savePaymentInfoRequestDTO = SavePaymentInfoRequestDTO(showId: concertId,
                                                                  salesTicketTypeId: selectedTicket.id,
                                                                  ticketCount: selectedTicket.count)
        
        let api = TicketingAPI.savePaymentInfo(requestDTO: savePaymentInfoRequestDTO)
        
        return self.networkService.request(api)
            .map(SavePaymentInfoResponseDTO.self)
    }
    
    func orderPayment(paymentKey: String,
                      amount: Int,
                      ticketingEntity: TicketingEntity) -> Single<OrderPaymentResponseDTO> {
        let concert = ticketingEntity.concert
        let selectedTicket = ticketingEntity.selectedTicket
        
        let depositor = ticketingEntity.depositor ?? ticketingEntity.ticketHolder

        let orderPaymentRequestDTO = OrderPaymentRequestDTO(orderId: ticketingEntity.orderId ?? "",
                                                            amount: amount,
                                                            paymentKey: paymentKey,
                                                            showId: concert.id,
                                                            salesTicketTypeId: selectedTicket.id,
                                                            ticketCount: selectedTicket.count,
                                                            reservationName: ticketingEntity.ticketHolder.name,
                                                            reservationPhoneNumber: ticketingEntity.ticketHolder.phoneNumber,
                                                            depositorName: depositor.name,
                                                            depositorPhoneNumber: depositor.phoneNumber)
        
        let api = TicketingAPI.orderPayment(requestDTO: orderPaymentRequestDTO)
        
        return self.networkService.request(api)
            .map(OrderPaymentResponseDTO.self)
    }
    
}
