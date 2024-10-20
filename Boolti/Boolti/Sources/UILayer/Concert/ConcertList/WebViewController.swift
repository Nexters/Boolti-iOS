import UIKit
import WebKit

import SnapKit
import RxSwift

// TODO: 재사용가능하게 변경하기
final class WebViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .backButton)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureSubviews()
        self.bindUIComponent()
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
        self.view.addSubview(navigationBar)

        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.prepareWebConfiguration { [weak self] config in
            guard let self = self, let config = config else { return }

            let webView = WKWebView(frame: .zero, configuration: config)
            self.view.addSubview(webView)

            webView.snp.makeConstraints { make in
                make.top.equalTo(self.navigationBar.snp.bottom)
                make.horizontalEdges.bottom.equalToSuperview()
            }
            
            guard let url = URL(string: Environment.REGISTER_CONCERT_URL) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    private func prepareWebConfiguration(completion: @escaping (WKWebViewConfiguration?) -> Void) {
        let accessToken = UserDefaults.accessToken
        let refreshToken = UserDefaults.refreshToken

        guard let authCookie = HTTPCookie(properties: [
            .domain: ".boolti.in",
            .path: "/",
            .name: "x-access-token",
            .value: accessToken,
            .secure: "TRUE",
        ]) else {
            return
        }

        guard let uuidCookie = HTTPCookie(properties: [
            .domain: ".boolti.in",
            .path: "/",
            .name: "x-refresh-token",
            .value: refreshToken,
            .secure: "TRUE",
        ]) else {
            return
        }

        WKWebViewConfiguration.includeCookie(cookies: [authCookie, uuidCookie]) {
            completion($0)
        }
    }
}
