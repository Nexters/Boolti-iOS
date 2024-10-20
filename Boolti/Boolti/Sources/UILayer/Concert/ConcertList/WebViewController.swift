import UIKit
import WebKit
import SnapKit


class WebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let accessToken = UserDefaults.accessToken
        let refreshToken = UserDefaults.refreshToken

        // WKWebView 설정
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        webView.uiDelegate = self
        view.addSubview(webView)

        // URL 설정
        let url = URL(string: "https://dotori.boolti.in/show/add")!

        // 쿠키 생성 및 설정
        let accessTokenCookie = HTTPCookie(properties: [
            .domain: url.host!,
            .path: "/",
            .name: "x-access-token",
            .value: accessToken,
            .secure: "TRUE",
            .expires: Date().addingTimeInterval(3600) // 1시간 후 만료
        ])!

        let refreshTokenCookie = HTTPCookie(properties: [
            .domain: url.host!,
            .path: "/",
            .name: "x-refresh-token",
            .value: refreshToken,
            .secure: "TRUE",
            .expires: Date().addingTimeInterval(2592000) // 30일 후 만료
        ])!

        // 쿠키 설정
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(accessTokenCookie) {
            self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(refreshTokenCookie) {
                // 두 쿠키가 모두 설정된 후 URL 로드
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
        }
    }
}
