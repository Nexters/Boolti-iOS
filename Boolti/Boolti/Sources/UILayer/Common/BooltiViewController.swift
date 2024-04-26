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
    
    private lazy var toastView = BooltiToastView()
    private let errorPopupView = BooltiPopupView()
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
        
        self.configurePopupView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit - ☠️☠️☠️☠️")
    }
    
    // MARK: Override
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Methods

extension BooltiViewController {

    @objc func showNetworkAlert() {
        self.errorPopupView.showPopup(with: .networkError)
    }

    @objc func navigateToRoot() {
        self.errorPopupView.showPopup(with: .refreshTokenHasExpired)
    }

    func showToast(message: String) {
        self.toastView.showToast.accept(message)
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
    
    private func configurePopupView() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showNetworkAlert),
            name: Notification.Name.serverError,
            object: nil
        )
        
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
        keyWindow.addSubview(self.errorPopupView)
        
        self.errorPopupView.snp.makeConstraints { make in
            make.edges.equalTo(keyWindow)
        }

        self.errorPopupView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                switch owner.errorPopupView.popupType {
                case .networkError:
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(1)
                    }
                case .refreshTokenHasExpired:
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    let scenedelegate = windowScene.delegate as? SceneDelegate
                    
                    let rootDIContainer = RootDIContainer()
                    let rootViewController = rootDIContainer.createRootViewController()
                    
                    scenedelegate?.window?.rootViewController = rootViewController
                    scenedelegate?.window?.makeKeyAndVisible()
                default:
                    break
                }
            }
            .disposed(by: self.errorPopupView.disposeBag)
            
    }
}
