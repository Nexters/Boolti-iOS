//
//  RefreshAuthAPIService.swift
//  Boolti
//
//  Created by Miro on 1/31/24.
//

import Foundation
import Moya
import RxSwift
import RxMoya

final class RefreshAuthAPIService {

    private let provider =  MoyaProvider<AuthAPI>()
    private let disposeBag = DisposeBag()

    func request(with refreshToken: String) -> Single<TokenRefreshResponseDTO>{
        let requestDTO = TokenRefreshRequestDTO(refreshToken: refreshToken)
        let API = AuthAPI.refresh(requestDTO: requestDTO)

        return self.provider.rx.request(API)
            .map(TokenRefreshResponseDTO.self)
    }
}
