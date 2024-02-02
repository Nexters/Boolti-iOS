//
//  BooltiViewController.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class BooltiViewController: UIViewController {

    private let loadingIndicatorView = BooltiLoadingIndicatorView(style: .large)

    var isLoading: Binder<Bool> {
        Binder(self) { [weak self] viewController, isLoading in
            guard let self = self else { return }
            if isLoading {
                viewController.view.bringSubviewToFront(self.loadingIndicatorView)
                self.loadingIndicatorView.isLoading = true
            } else {
                self.loadingIndicatorView.isLoading = false
            }
        }
    }
    
    private let toastView = BooltiToastView()
    
    var showToast: Binder<String> {
        Binder(self) { [weak self] viewController, message in
            guard let self = self else { return }
            self.toastView.showToast.accept(message)
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLoadingIndicatorView()
        self.configureToast()
    }

    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }

    private func configureLoadingIndicatorView() {
        self.view.addSubview(self.loadingIndicatorView)
        self.loadingIndicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureToast() {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else {
            return
        }
        keyWindow.addSubview(self.toastView)
        self.toastView.snp.makeConstraints { make in
            make.bottom.equalTo(keyWindow.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(keyWindow)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
