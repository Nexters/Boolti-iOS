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
    func popup(route: PopupShowView) -> Single<PopupEntity>
}

final class AppRepository: AppRepositoryType {
    
    let networkService: NetworkProviderType
    
    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
    
    func popup(route: PopupShowView) -> Single<PopupEntity> {
        let api = AppAPI.popup(route: route.rawValue)
        
        return networkService.request(api)
            .map(PopupResponseDTO.self)
            .map { $0.convertToPopuptEntities() }
    }

}
