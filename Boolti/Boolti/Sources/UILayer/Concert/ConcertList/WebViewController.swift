import UIKit
import WebKit

import SnapKit
import RxSwift

final class WebViewController: UIViewController, WKScriptMessageHandler {

    private var webView: WKWebView!
    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .backButton)

    var number = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpWebView()
        self.configureSubviews()
        self.bindUIComponent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadWebPage()
    }

    private func loadWebPage() {
        guard let url = URL(string: Environment.REGISTER_CONCERT_URL) else { return }
        //        guard let url = URL(string: "https://dotori.boolti.in/webview") else { return }

        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    private func setUpWebView() {
        let configuration = WKWebViewConfiguration()

        let contentController = WKUserContentController()
        contentController.add(self, name: "boolti")
        configuration.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: configuration)

        let userAgent = WKWebView().value(forKey: "userAgent")

        webView.customUserAgent = userAgent as! String + " BOOLTI/IOS"

        webView.allowsBackForwardNavigationGestures = true
    }

    private func bindUIComponent() {
        self.navigationBar.didBackButtonTap()
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func configureSubviews() {
        self.view.backgroundColor = .white00
        self.view.addSubviews([navigationBar, webView])

        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.webView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("📩 JS message received: \(message.body)")

        guard let bodyString = message.body as? String,
              let data = bodyString.data(using: .utf8),
              let body = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let id = body["id"] as? String,
              let timestamp = body["timestamp"],
              let commandStr = body["command"] as? String,
              let command = WebToAppCommand(rawValue: commandStr) else {
            return
        }

        let timestampString = "\(timestamp)"
        let payload = body["data"] as? [String: Any] ?? [:]

        switch command {
        case .navigateBack:
            print("🔙 Navigate Back")

        case .navigateToShowDetail:
            if let showId = payload["showId"] as? Int {
                print("🎭 Navigate to Show Detail with showId: \(showId)")
            } else {
                print("❌ Missing or invalid showId")
            }

        case .requestToken:
            let response: [String: Any] = [
                "id": id,
                "command": command.rawValue,
                "timestamp": timestampString,
                "data": [
                    "token": UserDefaults.accessToken
                ]
            ]

            if let jsonData = try? JSONSerialization.data(withJSONObject: response),
               let jsonString = String(data: jsonData, encoding: .utf8) {

                let js = "javascript:__boolti__webview__bridge__.postMessage(\(jsonString));"

                self.webView.evaluateJavaScript(js) { result, error in
                    if let error = error {
                        print("❌ JS eval error: \(error)")
                    } else {
                        print("✅ JS message sent: \(jsonString)")
                    }
                }
            }

        case .showToast:
            if let message = payload["message"] as? String,
               let durationStr = payload["duration"] as? String {
                print("🍞 Show toast")
            } else {
                print("❌ Invalid toast parameters")
            }
        }
    }

}
