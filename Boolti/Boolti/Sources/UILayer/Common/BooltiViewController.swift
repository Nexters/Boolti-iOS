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
    
    // MARK: UI Component
    
    private var toastView: BooltiToastView?
    private var popupView = BooltiPopupView()
    private var loadingIndicatorView: BooltiLoadingIndicatorView?
    
    // MARK: Properties
    
    var isLoading: Binder<Bool> {
        Binder(self) { [weak self] viewController, isLoading in
            guard let self = self, let loadingIndicatorView = self.loadingIndicatorView else { return }
            if isLoading {
                viewController.view.bringSubviewToFront(loadingIndicatorView)
                loadingIndicatorView.isLoading = true
            } else {
                loadingIndicatorView.isLoading = false
            }
        }
    }
    
    // MARK: Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePopupView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showNetworkAlert),
            name: Notification.Name("ServerErrorNotification"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(navigateToRoot),
            name: Notification.Name.refreshTokenHasExpired,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Override
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Methods

extension BooltiViewController {

    @objc func showNetworkAlert() {
        self.popupView.showPopup.accept("네트워크 오류가 발생했습니다\n잠시후 다시 시도해주세요")
    }

    @objc func navigateToRoot() {

        let alertController = UIAlertController(
            title: "오류",
            message: "로그인 세션이 만료되었습니다.\n앱을 다시 시작해주세요",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "다시 시작하기", style: .default, handler: { _ in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            let scenedelegate = windowScene.delegate as? SceneDelegate

            let rootDIContainer = RootDIContainer()
            let rootViewController = rootDIContainer.createRootViewController()

            scenedelegate?.window?.rootViewController = rootViewController
            scenedelegate?.window?.makeKeyAndVisible()

        })
        alertController.addAction(okAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func showToast(message: String) {
        self.toastView?.showToast.accept(message)
    }

    func showPopup(title: String) {
        self.popupView.showPopup.accept(title)
    }
}

// MARK: - UI

extension BooltiViewController {
    
    func configureLoadingIndicatorView() {
        self.loadingIndicatorView = BooltiLoadingIndicatorView(style: .large)
        
        self.view.addSubview(self.loadingIndicatorView ?? BooltiLoadingIndicatorView(style: .large))
        self.loadingIndicatorView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureToastView(isButtonExisted: Bool) {
        self.toastView = BooltiToastView()
        
        let bottomOffset = isButtonExisted ? 80 : 20
        
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else {
            return
        }
        keyWindow.addSubview(self.toastView ?? BooltiToastView())
        self.toastView?.snp.makeConstraints { make in
            make.bottom.equalTo(keyWindow.safeAreaLayoutGuide).offset(-bottomOffset)
            make.centerX.equalTo(keyWindow)
        }
    }
    
    private func configurePopupView() {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else {
            return
        }
        keyWindow.addSubview(self.popupView)
        self.popupView.snp.makeConstraints { make in
            make.edges.equalTo(keyWindow)
        }
    }
}
