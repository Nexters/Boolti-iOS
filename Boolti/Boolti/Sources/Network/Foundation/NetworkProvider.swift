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
                    #if DEBUG
                    do {
                        let data = response.data
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            let prettyPrintedData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                                print("========================================")
                                print("JSON Response:\n\(prettyPrintedString)")
                                print("========================================")
                            }
                        } else {
                            print("Error parsing JSON: Unable to convert response data to dictionary.")
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                    #endif
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
