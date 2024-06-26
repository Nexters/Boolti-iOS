//
//  TicketReservationsRepository.swift
//  Boolti
//
//  Created by Miro on 2/10/24.
//

import Foundation

import RxSwift

protocol TicketReservationsRepositoryType {
    
    var networkService: NetworkProviderType { get }
    func ticketReservations() -> Single<[TicketReservationItemEntity]>
    func ticketReservationDetail(with reservationID: String) -> Single<TicketReservationDetailEntity>
    func requestRefund(with requestDTO: TicketRefundRequestDTO) -> Single<Void>
}

final class TicketReservationRepository: TicketReservationsRepositoryType {

    let networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    func ticketReservations() -> Single<[TicketReservationItemEntity]> {

        let api = TicketReservationAPI.reservations
        return self.networkService.request(api)
            .map([TicketReservationItemResponseDTO].self)
            .map { $0.map { $0.convertToTicketReservationItemEntity() }}
    }

    func ticketReservationDetail(with reservationID: String) -> Single<TicketReservationDetailEntity> {
        let requestDTO = TicketReservationDetailRequestDTO(reservationID: reservationID)
        let api = TicketReservationAPI.detail(requestDTO: requestDTO)
        return self.networkService.request(api)
            .map(TicketReservationDetailResponseDTO.self)
            .map { $0.convertToTicketReservationDetailEntity() }
    }

    func requestRefund(with requestDTO: TicketRefundRequestDTO) -> Single<Void> {
        let api = TicketReservationAPI.requestRefund(requestDTO: requestDTO)
        return self.networkService.request(api)
            .map { _ in () } // 에러 핸들링 예정!..
    }
}
