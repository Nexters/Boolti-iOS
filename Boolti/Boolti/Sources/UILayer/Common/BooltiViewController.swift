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
    
    // MARK: Properties
    
    private let testDisposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private lazy var toastView = BooltiToastView()
    private let networkErrorPopupView = BooltiPopupView()
    private let refreshTokenHasExpiredPopupView = BooltiPopupView()
    private lazy var loadingIndicatorView = BooltiLoadingIndicatorView(style: .large)
    
    // MARK: Properties
    
    var isLoading: Binder<Bool> {
        Binder(self) { [weak self] viewController, isLoading in
            guard let self = self else { return }
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
        
        self.configureNetworkErrorPopupView()
        self.configureRefreshTokenHasExpiredPopupView()
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
        self.networkErrorPopupView.showPopup.accept("네트워크 오류가 발생했습니다\n잠시후 다시 시도해주세요")
    }

    @objc func navigateToRoot() {
        self.refreshTokenHasExpiredPopupView.showPopup.accept("로그인 세션이 만료되었습니다\n앱을 다시 시작해주세요")
    }

    func showToast(message: String) {
        self.toastView.showToast.accept(message)
    }

    func showPopup(title: String) {
        self.networkErrorPopupView.showPopup.accept(title)
    }
}

// MARK: - UI

extension BooltiViewController {
    
    func configureLoadingIndicatorView() {
        self.view.addSubview(self.loadingIndicatorView)
        self.loadingIndicatorView.snp.makeConstraints { make in
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
        keyWindow.addSubview(self.toastView)
        self.toastView.snp.makeConstraints { make in
            make.bottom.equalTo(keyWindow.safeAreaLayoutGuide).offset(-bottomOffset)
            make.centerX.equalTo(keyWindow)
        }
    }
    
    private func configureNetworkErrorPopupView() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showNetworkAlert),
            name: Notification.Name.serverError,
            object: nil
        )
        
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else {
            return
        }
        keyWindow.addSubview(self.networkErrorPopupView)
        self.networkErrorPopupView.snp.makeConstraints { make in
            make.edges.equalTo(keyWindow)
        }
        
        self.networkErrorPopupView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    exit(1)
                }
            }
            .disposed(by: self.testDisposeBag)
    }
    
    private func configureRefreshTokenHasExpiredPopupView() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(navigateToRoot),
            name: Notification.Name.refreshTokenHasExpired,
            object: nil
        )
        
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else {
            return
        }
        keyWindow.addSubview(self.refreshTokenHasExpiredPopupView)
        self.refreshTokenHasExpiredPopupView.snp.makeConstraints { make in
            make.edges.equalTo(keyWindow)
        }
        
        self.refreshTokenHasExpiredPopupView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                let scenedelegate = windowScene.delegate as? SceneDelegate

                let rootDIContainer = RootDIContainer()
                let rootViewController = rootDIContainer.createRootViewController()

                scenedelegate?.window?.rootViewController = rootViewController
                scenedelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: self.testDisposeBag)
    }
}
