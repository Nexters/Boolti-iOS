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

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLoadingIndicatorView()
    }

    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }

    private func setupLoadingIndicatorView() {
        self.view.addSubview(self.loadingIndicatorView)
        self.loadingIndicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
