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
    associatedtype API: BaseAPI
    
    func request(_ api: API, file: StaticString, function: StaticString, line: UInt) -> Single<Response>
}

extension Networking {
    
    func request(
        _ api: API,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        self.request(api, file: file, function: function, line: line)
    }
}

final class NetworkProvider<API: BaseAPI>: Networking {

    private let provider: MoyaProvider<API>
    
    init(plugins: [PluginType] = []) {
        let session = Session(interceptor: NetworkIntercepter())
        session.sessionConfiguration.timeoutIntervalForRequest = 10
     
        self.provider = MoyaProvider<API>(session: session, plugins: plugins)
    }
    
    func request(
        _ api: API,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        let requestString = "\(api.path)"
        return provider.rx.request(api)
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

