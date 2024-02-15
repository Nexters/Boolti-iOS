//
//  TicketReservationsRepositoryType.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/15/24.
//

import RxSwift

protocol TicketReservationsRepositoryType {
    var networkService: NetworkProviderType { get }
    func ticketReservations() -> Single<[TicketReservationItemEntity]>
    func ticketReservationDetail(with reservationID: String) -> Single<TicketReservationDetailEntity>
    func requestRefund(with requestDTO: TicketRefundRequestDTO) -> Single<Void>
}
