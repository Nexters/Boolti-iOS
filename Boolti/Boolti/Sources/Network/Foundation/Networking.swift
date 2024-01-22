//
//  Networking.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import RxSwift
import RxMoya
import Moya

protocol Networking {
    func request(_ api: BaseAPI) -> Single<Response>
}

final class NetworkProvider: Networking {
    
    private let provider: MoyaProvider<MultiTarget>
    
    init(plugins: [PluginType] = []) {
        let session = Session(interceptor: AuthInterceptor())
        session.sessionConfiguration.timeoutIntervalForRequest = 10

        self.provider = MoyaProvider<MultiTarget>(session: session, plugins: plugins)
    }

    func request(_ api: BaseAPI) -> Single<Response> {
        let requestString = "\(api.path)"
        let endpoint = MultiTarget.target(api)

        return provider.rx.request(endpoint)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { response in
                    print("SUCCESS: \(requestString) (\(response.statusCode))")
                },
                onError: { _ in
                    print("ERROR: \(requestString)")
                },
                onSubscribed: {
                    print("REQUEST: \(requestString)")
                }
            )
    }
}
