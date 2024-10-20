//
//  WKWebViewConfiguration+.swift
//  Boolti
//
//  Created by Miro on 10/21/24.
//

import Foundation
import WebKit

// TODO: 쿠키 넣는 법 다시 학습하기
extension WKWebViewConfiguration {

    static func includeCookie(cookies: [HTTPCookie], completion: @escaping (WKWebViewConfiguration?) -> Void) {
        let config = WKWebViewConfiguration()
        let dataStore = WKWebsiteDataStore.nonPersistent()

        DispatchQueue.main.async {
            let waitGroup = DispatchGroup()

            for cookie in cookies {
                waitGroup.enter()
                dataStore.httpCookieStore.setCookie(cookie) {
                    waitGroup.leave()
                }
            }

            waitGroup.notify(queue: DispatchQueue.main) {
                config.websiteDataStore = dataStore
                completion(config)
            }
        }
    }

}
