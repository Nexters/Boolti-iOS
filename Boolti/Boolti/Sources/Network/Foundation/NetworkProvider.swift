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

final class NetworkProvider: NetworkProviderType {

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
            .do(
                onSuccess: { response in
                    print("⭕️ SUCCESS: \(requestString) (\(response.statusCode))")
                    #if DEBUG
                    do {
                        let data = response.data

                        guard !data.isEmpty else { return }
                        
                        if let stringValue = String(data: data, encoding: .utf8),
                           let boolValue = Bool(stringValue) {
                            print("========================================")
                            print("Boolean Response: \(boolValue)")
                            print("========================================")
                            return
                        }
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonArray = json as? [[String: Any]] {
                            let prettyPrintedData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
                            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                                print("========================================")
                                print("JSON Response (Array):\n\(prettyPrintedString)")
                                print("========================================")
                            }
                        } else if let jsonDict = json as? [String: Any] {
                            let prettyPrintedData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
                            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                                print("========================================")
                                print("JSON Response (Dictionary):\n\(prettyPrintedString)")
                                print("========================================")
                            }
                        }
                    } catch {
                        print("========================================")
                        print("Response Decoding Error")
                        print("========================================")
                    }
                    #endif
                },
                onError: { error in
                    if let moyaError = error as? MoyaError {
                        if let response = moyaError.response {
                            print("❌ ERROR: \(requestString) (\(response.statusCode))")
                            
                            if response.statusCode == 500 {
                                NotificationCenter.default.post(name: Notification.Name("ServerErrorNotification"), object: nil)
                            }
                        } else {
                            print("❌ ERROR: \(requestString) (No response)")
                        }
                    } else {
                        print("❌ ERROR: \(requestString) (\(error.localizedDescription))")
                    }
                },
                onSubscribed: {
                    print("❓ REQUEST: \(requestString)")
                }
            )
    }
}
