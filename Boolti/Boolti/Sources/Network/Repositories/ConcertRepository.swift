//
//  ConcertRepository.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import Foundation

import RxSwift

protocol ConcertRepositoryType: RepositoryType {
    var networkService: NetworkProviderType { get }
    func concertList(concertName: String?) -> Single<[ConcertEntity]>
    func concertDetail(concertId: Int) -> Single<ConcertDetailEntity>
    func salesTicket(concertId: Int) -> Single<[SelectedTicketEntity]>
    func castTeamList(concertId: Int) -> Single<[ConcertCastTeamListEntity]>
}

final class ConcertRepository: ConcertRepositoryType {
    
    let networkService: NetworkProviderType
    
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
        let api = TicketingAPI.salesTicket(requestDTO: salesTicketRequestDTO)
        
        return networkService.request(api)
            .map(SalesTicketResponseDTO.self)
            .map { $0.convertToSalesTicketEntities() }
    }

    func castTeamList(concertId: Int) -> Single<[ConcertCastTeamListEntity]> {
        let castTeamListRequestDTO = ConcertCastTeamListRequestDTO(showID: concertId)
        let api = ConcertAPI.castTeamList(requestDTO: castTeamListRequestDTO)

        return networkService.request(api)
            .map([ConcertCastTeamListResponseDTO].self)
            .map { return $0.map { dto in
                dto.convertToTeamListEntity()
            } }
    }

    func userProfile(userCode: String) -> Single<ProfileEntity> {
        let concertUserProfileRequestDTO = ConcertUserProfileRequestDTO(userCode: userCode)
        let api = ConcertAPI.userProfile(requsetDTO: concertUserProfileRequestDTO)

        return networkService.request(api)
            .map(ConcertUserProfileResponseDTO.self)
            .map { $0.convertToUserProfile() }
    }
}
