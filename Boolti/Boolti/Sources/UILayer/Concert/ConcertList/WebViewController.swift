import UIKit
import WebKit
import SnapKit
import RxSwift

protocol WebViewMessageHandler: AnyObject {
    func handleWebMessage(command: WebToAppCommand, payload: [String: Any])
}

final class WebViewController: BooltiViewController, WKScriptMessageHandler {

    private var webView: WKWebView!
    private let disposeBag = DisposeBag()
    private let navigationBar = BooltiNavigationBar(type: .backButton)
    private let refreshAuthRepository = RefreshAuthRepository()

    private let url: URL
    private var messageHandler: WebViewMessageHandler

    // MARK: - Initializer
    init(url: URL, messageHandler: WebViewMessageHandler) {
        self.url = url
        self.messageHandler = messageHandler
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpWebView()
        self.configureSubviews()
        self.configureToastView(isButtonExisted: false)
        self.bindUIComponent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "boolti")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadWebPage()
    }

    // MARK: - WebView Setup
    private func loadWebPage() {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    private func setUpWebView() {
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(self, name: "boolti")
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)

        let userAgent = WKWebView().value(forKey: "userAgent") as? String ?? ""
        webView.customUserAgent = userAgent + " BOOLTI/IOS"

        webView.allowsBackForwardNavigationGestures = true
    }

    // MARK: - Layout
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

    // MARK: - JS 메시지 처리
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
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
        case .requestToken:
            let refreshToken = UserDefaults.refreshToken
            self.refreshAuthRepository.request(with: refreshToken)
                .subscribe(onSuccess: { tokenRefreshResponseDTO in
                    guard let accessToken = tokenRefreshResponseDTO.accessToken,
                          let  refreshToken = tokenRefreshResponseDTO.refreshToken
                    else { return }
                    UserDefaults.accessToken = accessToken
                    UserDefaults.refreshToken = refreshToken

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
                        self.webView.evaluateJavaScript(js)
                    }
                }, onFailure: { error in
                    UserDefaults.accessToken = ""
                    UserDefaults.refreshToken = ""

                    NotificationCenter.default.post(name: Notification.Name.refreshTokenHasExpired, object: nil)
                })
                .disposed(by: self.disposeBag)

        case .showToast:
            guard let message = payload["message"] as? String,
                  let duration = payload["duration"] as? String
            else { return }
            self.showToast(message: message)

        case .navigateBack:
            self.navigationController?.popViewController(animated: true)

        default:
            self.messageHandler.handleWebMessage(command: command, payload: payload)
        }
    }
}
