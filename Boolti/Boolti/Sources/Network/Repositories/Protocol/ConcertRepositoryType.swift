//
//  ConcertRepositoryType.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import RxSwift

protocol ConcertRepositoryType {

    var networkService: NetworkProviderType { get }
    func concertList(concertName: String?) -> Single<[ConcertEntity]>
    func concertDetail(concertId: Int) -> Single<ConcertDetailEntity>
    func salesTicket(concertId: Int) -> Single<[SalesTicketEntity]>
    func salesTicketing(concertId: Int,
                        selectedTicket: SalesTicketEntity,
                        ticketHolderName: String,
                        ticketHolderPhoneNumber: String,
                        depositorName: String,
                        depositorPhoneNumber: String) -> Single<SalesTicketingResponseDTO>
}
