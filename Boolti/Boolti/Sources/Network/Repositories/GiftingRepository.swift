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
    func orderGiftPayment(paymentKey: String,
                      amount: Int,
                      giftingEntity: GiftingEntity) -> Single<OrderGiftPaymentResponseDTO>
    func freeGifting(giftingEntity: GiftingEntity) -> Single<OrderGiftPaymentResponseDTO>
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
    
    func orderGiftPayment(paymentKey: String,
                          amount: Int,
                          giftingEntity: GiftingEntity) -> Single<OrderGiftPaymentResponseDTO> {
        let concert = giftingEntity.concert
        let selectedTicket = giftingEntity.selectedTicket
                
        let orderGiftPaymentRequestDTO = OrderGiftPaymentRequestDTO(orderId: giftingEntity.orderId ?? "",
                                                                    amount: amount,
                                                                    paymentKey: paymentKey,
                                                                    showId: concert.id,
                                                                    salesTicketTypeId: selectedTicket.id,
                                                                    ticketCount: selectedTicket.count,
                                                                    giftImgId: giftingEntity.giftImgId,
                                                                    message: giftingEntity.message,
                                                                    senderName: giftingEntity.sender.name,
                                                                    senderPhoneNumber: giftingEntity.sender.phoneNumber,
                                                                    recipientName: giftingEntity.receiver.name,
                                                                    recipientPhoneNumber: giftingEntity.receiver.phoneNumber,
                                                                    depositorName: giftingEntity.sender.name,
                                                                    depositorPhoneNumber: giftingEntity.sender.phoneNumber)
        
        let api = GiftingAPI.orderGiftPayment(requestDTO: orderGiftPaymentRequestDTO)
        
        return self.networkService.request(api)
            .map(OrderGiftPaymentResponseDTO.self)
    }
    
    func freeGifting(giftingEntity: GiftingEntity) -> Single<OrderGiftPaymentResponseDTO> {
        let freeGiftingRequestDTO = FreeGiftingRequestDTO(amount: 0,
                                                          showId: giftingEntity.concert.id,
                                                          salesTicketTypeId: giftingEntity.selectedTicket.id,
                                                          ticketCount: giftingEntity.selectedTicket.count,
                                                          giftImgId: giftingEntity.giftImgId,
                                                          message: giftingEntity.message,
                                                          senderName: giftingEntity.sender.name,
                                                          senderPhoneNumber: giftingEntity.sender.phoneNumber,
                                                          recipientName: giftingEntity.receiver.name,
                                                          recipientPhoneNumber: giftingEntity.receiver.phoneNumber,
                                                          depositorName: giftingEntity.sender.name,
                                                          depositorPhoneNumber: giftingEntity.sender.phoneNumber)
        
        let api = GiftingAPI.freeGifting(requestDTO: freeGiftingRequestDTO)
        
        return networkService.request(api)
            .map(OrderGiftPaymentResponseDTO.self)
    }
    
}
