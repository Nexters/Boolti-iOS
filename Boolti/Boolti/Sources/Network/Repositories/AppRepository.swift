//
//  AppRepository.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/15/25.
//

import Foundation

import RxSwift

protocol AppRepositoryType: RepositoryType {
    
    var networkService: NetworkProviderType { get }
    func popup() -> Single<PopupEntity>
}

final class AppRepository: AppRepositoryType {
    
    let networkService: NetworkProviderType
    
    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
    
    func popup() -> Single<PopupEntity> {
        let api = AppAPI.popup
        
        return networkService.request(api)
            .map(PopupResponseDTO.self)
            .map { $0.convertToPopuptEntities() }
    }

}
