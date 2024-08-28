//
//  AgreementViewController.swift
//  Boolti
//
//  Created by Miro on 8/27/24.
//

import UIKit
import WebKit

import SnapKit

final class AgreementViewController: UIViewController {

    private let webView = WKWebView()
    private let url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureWebView()
    }

    private func configureWebView() {
        self.configureConstraints()
        self.view.backgroundColor = .grey85
        self.webView.scrollView.backgroundColor = .grey85
        self.webView.scrollView.isScrollEnabled = false
        self.webView.allowsLinkPreview = true /// RBSServiceErrorDomain Console 에러 해결
        let request = URLRequest(url: self.url)
        self.webView.load(request)
    }

    private func configureConstraints() {
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
