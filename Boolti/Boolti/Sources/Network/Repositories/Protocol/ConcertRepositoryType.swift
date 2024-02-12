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
    func salesTicket(concertId: Int) -> Single<[SelectedTicketEntity]>
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
