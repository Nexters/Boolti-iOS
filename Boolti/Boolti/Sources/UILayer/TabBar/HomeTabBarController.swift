//
//  HomeTabBarController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

import RxSwift

final class HomeTabBarController: UITabBarController {
    
    // MARK: Properties

    private let viewModel: HomeTabBarViewModel
    private let viewControllerFactory: (HomeTab) -> UIViewController
    private let disposeBag = DisposeBag()
    
    // MARK: Init

    init(
        viewModel: HomeTabBarViewModel,
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
        
        self.configureUI()
        self.bind()
    }
}

// MARK: - Methods

extension HomeTabBarController {
    
    private func bind() {
        self.rx.didSelect.distinctUntilChanged()
            .map { [weak self] selected in self?.viewControllers?.firstIndex(where: { selected === $0 }) }
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, index in
                owner.viewModel.selectTab(index: index)
            }
            .disposed(by: self.disposeBag)

        viewModel.tabItems.distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, tabItems in
                let viewControllers = tabItems.map { tabItem -> UIViewController in
                    let viewController = owner.viewControllerFactory(tabItem)
                    return viewController
                }
                owner.setViewControllers(viewControllers, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.currentTab.distinctUntilChanged()
            .map { $0.rawValue }
            .filter { [weak self] currentTab in
                let isVaildTab = currentTab < self?.viewControllers?.count ?? 0
                let isNotSameTab = currentTab != self?.selectedIndex
                return isVaildTab && isNotSameTab
            }
            .subscribe(with: self, onNext: { owner, selectedIndex in
                owner.selectedIndex = selectedIndex
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI

extension HomeTabBarController {
    
    private func configureUI() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .grey95
        
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        self.tabBar.tintColor = .grey10
        self.tabBar.unselectedItemTintColor = .grey50
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.grey85.cgColor
        self.tabBar.layer.addSublayer(topBorder)
    }
}
