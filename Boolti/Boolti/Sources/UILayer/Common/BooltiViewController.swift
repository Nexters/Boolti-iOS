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
    }

    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    // MARK: Override
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Methods

extension BooltiViewController {
    
    func configureLoadingIndicatorView() {
        self.loadingIndicatorView = BooltiLoadingIndicatorView(style: .large)
        
        self.view.addSubview(self.loadingIndicatorView ?? BooltiLoadingIndicatorView(style: .large))
        self.loadingIndicatorView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureToastView(isbuttonExisted: Bool) {
        self.toastView = BooltiToastView()
        
        let bottomOffset = isbuttonExisted ? 80 : 20
        
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
    
    func showToast(message: String) {
        self.toastView?.showToast.accept(message)
    }
}
