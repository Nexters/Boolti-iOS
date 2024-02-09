//
//  AuthInterceptor.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation
import Alamofire

import RxSwift

final class AuthInterceptor: RequestInterceptor {
    
    private let disposeBag = DisposeBag()
    private let refreshAuthRepository = RefreshAuthRepository()

    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {

        var urlRequest = urlRequest

        if let urlString = urlRequest.url?.absoluteString, urlString.contains("/api") || urlString.contains("/logout") {
            urlRequest.headers.add(.authorization(bearerToken: UserDefaults.accessToken))
        }

        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request,
               for _: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        // 401(토큰 재발급 이슈)일 경우에는 밑으로 넘어가고,
        // 만약 다른 문제라면? retry를 하지 않는다.
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // 리프레시 요청 response의 statusCdoe가 401이면 재요청 하지 않음
        if let urlString = response.url?.absoluteString, urlString.hasSuffix("/refeshToken") {
            completion(.doNotRetry)
            return
        }
        
        // 현재 401이므로, refreshToken으로 API 호출을 한다.
        let refreshToken = UserDefaults.refreshToken
        self.refreshAuthRepository.request(with: refreshToken)
            .subscribe(onSuccess: { tokenRefreshResponseDTO in
                guard let accessToken = tokenRefreshResponseDTO.accessToken,
                      let  refreshToken = tokenRefreshResponseDTO.refreshToken
                else { return }
                UserDefaults.accessToken = accessToken
                UserDefaults.refreshToken = refreshToken

                completion(.retry)
            }, onFailure: { error in
                // 이러면 로그인 화면으로 간다!..
                completion(.doNotRetry)
            })
            .disposed(by: self.disposeBag)
    }
}
