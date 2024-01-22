//
//  RootViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

final class RootViewController: UIViewController {

    private let viewModel: RootViewModel
    private let splashViewControllerFactory: () -> SplashViewController
    private let tabBarControllerFactory: () -> TabBarController
    
    init(
        viewModel: RootViewModel,
        splashViewControllerFactory: @escaping () -> SplashViewController,
        tabBarControllerFactory: @escaping () -> TabBarController
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
        
        // TODO: 화면 넘어가는 거 확인용. 나중에 지워야함!
        self.view.backgroundColor = .red
        
        let splashDuration: DispatchTimeInterval = .seconds(2)

        DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) { [weak self] in
            let splashViewController = self?.splashViewControllerFactory() ?? UIViewController()
            self?.navigationController?.pushViewController(splashViewController, animated: true)
            
//            let tabBarController = self?.tabBarControllerFactory() ?? UITabBarController()
//            tabBarController.modalTransitionStyle = .crossDissolve
//            tabBarController.modalPresentationStyle = .overFullScreen
//            self?.present(tabBarController, animated: true)
        }
    }

}

extension RootViewController: SplashViewControllerDelegate {

    func splashViewController(_ didSplashViewDismissed: SplashViewModel) {
    }
    // TODO: Delegate을 활용해서 Splash View -> RootView -> TabBar로 넘어가는 로직 구현할 예정!

        // HomeTab으로 navigate하기!..
//        if let presentedViewController = self.presentedViewController {
//            presentedViewController.dismiss(animated: false, completion: { [weak self] in
//                viewController.modalPresentationStyle = .fullScreen
//                self?.present(viewController, animated: animated, completion: nil)
//            })
//        } else {
//            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: animated, completion: nil)
//        }
//    }
}
