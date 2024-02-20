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
    private let homeTabBarControllerFactory: () -> HomeTabBarController

    init(
        viewModel: RootViewModel,
        splashViewControllerFactory: @escaping () -> SplashViewController,
        hometabBarControllerFactory: @escaping () -> HomeTabBarController
    ) {
        self.viewModel = viewModel
        self.splashViewControllerFactory = splashViewControllerFactory
        self.homeTabBarControllerFactory = hometabBarControllerFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()

        self.view.backgroundColor = .grey95
    }

    private func bind() {
        self.rx.viewDidAppear
            .take(1)
            .flatMapFirst { _ in self.viewModel.navigation }
            .subscribe(onNext: { [weak self] destination in
                let viewController = self?.createViewController(destination) ?? UIViewController()
                switch destination {
                case .splash:
                    viewController.modalPresentationStyle = .overFullScreen
                    viewController.modalTransitionStyle = .crossDissolve
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
        case .homeTab: return homeTabBarControllerFactory()
        }
    }
}
