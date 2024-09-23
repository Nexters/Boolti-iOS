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

        if urlRequest.method == .put {
            debugPrint("🔥 이미지 업로드 요청 🔥")
        } else {
            urlRequest.headers.add(.authorization(bearerToken: UserDefaults.accessToken))
            
            debugPrint("🔥 요청한 AccessToken: \(UserDefaults.accessToken) 🔥")
            debugPrint("🔥 요청한 userId: \(UserDefaults.userId) 🔥")
        }

        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request,
               for _: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        // 401(토큰 재발급 이슈)일 경우에는 밑으로 넘어가고,
        // 만약 다른 문제라면? retry를 하지 않는다.
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == NetworkError.unauthorized.rawValue
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
                UserDefaults.accessToken = ""
                UserDefaults.refreshToken = ""

                NotificationCenter.default.post(name: Notification.Name.refreshTokenHasExpired, object: nil)
                completion(.doNotRetry)
            })
            .disposed(by: self.disposeBag)
    }
}
