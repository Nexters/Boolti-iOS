//
//  RootViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState

final class RootViewController: UIViewController {

    private let viewModel: RootViewModel
    private let disposeBag = DisposeBag()

    private let splashViewControllerFactory: () -> SplashViewController
    private let tabBarControllerFactory: () -> HomeTabBarController

    init(
        viewModel: RootViewModel,
        splashViewControllerFactory: @escaping () -> SplashViewController,
        tabBarControllerFactory: @escaping () -> HomeTabBarController
    ) {
        self.viewModel = viewModel
        self.splashViewControllerFactory = splashViewControllerFactory
        self.tabBarControllerFactory = tabBarControllerFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()

        // TODO: 화면 넘어가는 거 확인용. 나중에 지워야함!
        self.view.backgroundColor = .red
    }

    private func bind() {
        self.rx.viewDidAppear
            .take(1)
            .flatMapFirst { _ in self.viewModel.navigation }
            .subscribe(onNext: { [weak self] destination in
                let viewController = self?.createViewController(destination) ?? UIViewController()
                switch destination {
                case .splash:
                    viewController.modalPresentationStyle = .fullScreen
                    self?.present(viewController, animated: true, completion: nil)
                case .homeTab:
                    if let presentedViewController = self?.presentedViewController {
                        presentedViewController.dismiss(animated: false, completion: { [weak self] in
                            viewController.modalTransitionStyle = .crossDissolve
                            viewController.modalPresentationStyle = .overFullScreen
                            self?.present(viewController, animated: true, completion: nil)
                        })
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func createViewController(_ next: RootDestination) -> UIViewController {
        switch next {
        case .splash: return splashViewControllerFactory()
        case .homeTab: return tabBarControllerFactory()
        }
    }
}
