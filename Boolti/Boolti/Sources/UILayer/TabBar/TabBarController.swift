//
//  TabBarController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit
import RxSwift

final class TabBarController: UITabBarController {

    private let viewModel: TabBarViewModel
    private let viewControllerFactory: (HomeTab) -> UIViewController
    private let disposeBag = DisposeBag()

    init(
        viewModel: TabBarViewModel,
        viewControllerFactory: @escaping (HomeTab) -> UIViewController
    ) {
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {

        self.rx.didSelect.distinctUntilChanged()
            .map { [weak self] selected in self?.viewControllers?.firstIndex(where: { selected === $0 }) }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                self?.viewModel.selectTab(index: $0)
            })
            .disposed(by: disposeBag)

        viewModel.tabItems.distinctUntilChanged()
            .subscribe( onNext: { [weak self] tabItems in
                guard let self = self else { return }
                let viewControllers = tabItems.map { tabItem -> UIViewController in
                    let viewController = self.viewControllerFactory(tabItem)
                    return viewController
                }
                self.setViewControllers(viewControllers, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.currentTab.distinctUntilChanged()
            .map { $0.rawValue }
            .filter { [weak self] currentTab in
                let isVaildTab = currentTab < self?.viewControllers?.count ?? 0
                let isNotSameTab = currentTab != self?.selectedIndex
                return isVaildTab && isNotSameTab
            }.subscribe(onNext: { [weak self] selectedIndex in
                self?.selectedIndex = selectedIndex
            })
            .disposed(by: disposeBag)
    }


}
