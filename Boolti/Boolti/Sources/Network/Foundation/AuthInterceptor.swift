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
 
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var urlRequest = urlRequest
        
        // refesh 재발급 경로면 refresh token을 넣음
        if let urlString = urlRequest.url?.absoluteString, urlString.hasSuffix("/refeshToken") {
            urlRequest.headers.add(.authorization(bearerToken: UserDefaults.refreshToken))
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request,
               for _: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
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
        
        // 토큰 재발급 요청 (401일 떄)
//        ReissueAPIService.shared.reissueAuthentication()
//            .subscribe(onSuccess: { result in
//              // userdefault에 새로 저장
//                completion(.retry)
//            }, onFailure: { error in
//                // refreshToken 만료 시 로그인 화면으로 전환
//                NotificationCenter.default.post(name: NotificationCenterKey.refreshTokenHasExpired, object: nil)
//                completion(.doNotRetryWithError(error))
//            })
//            .disposed(by: disposeBag)
    }
}
