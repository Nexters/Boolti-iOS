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
                    debugPrint("⭕️ SUCCESS: \(requestString) (\(response.statusCode))")
                    
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
                            debugPrint("❌ ERROR: \(requestString) (\(response.statusCode))")
                            
                            #if DEBUG
                            let data = response.data
                            
                            guard !data.isEmpty else { return }
                            
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            if let jsonDict = json as? [String: Any] {
                                let prettyPrintedData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
                                if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                                    print("========================================")
                                    print("ERROR Response:\n\(prettyPrintedString)")
                                    print("========================================")
                                }
                            }
                            #endif
                            
                            if response.statusCode == NetworkError.serverError.rawValue {
                                NotificationCenter.default.post(name: Notification.Name.serverError, object: nil)
                            }
                        } else {
                            debugPrint("❌ ERROR: \(requestString) (No response)")
                        }
                    } else {
                        debugPrint("❌ ERROR: \(requestString) (\(error.localizedDescription))")
                    }
                },
                onSubscribed: {
                    debugPrint("❓ REQUEST: \(requestString)")
                }
            )
    }
}
