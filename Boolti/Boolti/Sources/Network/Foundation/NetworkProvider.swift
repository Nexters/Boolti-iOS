//
//  NetworkProvider.swift
//  Boolti
//
//  Created by Miro on 1/22/24.
//

import Foundation

import RxSwift
import RxMoya
import Moya

class NetworkProvider: NetworkProviderType {

    private let provider: MoyaProvider<MultiTarget>

    init(plugins: [PluginType] = []) {
        let session = Session(interceptor: AuthInterceptor())
        session.sessionConfiguration.timeoutIntervalForRequest = 10

        self.provider = MoyaProvider<MultiTarget>(session: session, plugins: plugins)
    }

    func request(_ api: ServiceAPI) -> Single<Response> {
        let requestString = "\(api.path)"
        let endpoint = MultiTarget.target(api)

        return provider.rx.request(endpoint)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { response in
                    print("SUCCESS: \(requestString) (\(response.statusCode))")
//                    #if DEBUG
//                    do {
//                        let data = response.data
//
//                        guard !data.isEmpty else { return }
//
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        if let jsonArray = json as? [[String: Any]] {
//                            let prettyPrintedData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
//                            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
//                                print("========================================")
//                                print("JSON Response (Array):\n\(prettyPrintedString)")
//                                print("========================================")
//                            }
//                        } else if let jsonDict = json as? [String: Any] {
//                            let prettyPrintedData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
//                            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
//                                print("========================================")
//                                print("JSON Response (Dictionary):\n\(prettyPrintedString)")
//                                print("========================================")
//                            }
//                        }
//                    }
//                    #endif
                },
                onError: { response in
                    print("ERROR: \(requestString) (\(response.localizedDescription))")
                },
                onSubscribed: {
                    print("REQUEST: \(requestString)")
                }
            )
    }
}
