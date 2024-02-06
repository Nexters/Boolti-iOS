//
//  SplashViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit
import RxSwift

final class SplashViewController: UIViewController {

    // 여기서 Token이 있는 지 확인해서
    // 아예 AuthenticationRepository에 Home에서 해당 Token을 넣어주는 것도 좋을 듯
    // Authentication은 프로퍼티로 토큰을 갖고!..
    
    // MARK: Properties

    private let viewModel: SplashViewModel
    private let disposeBag = DisposeBag()
    
    private let updatePopupViewControllerFactory: () -> UpdatePopupViewController
    
    // MARK: Life Cycle
    
    init(viewModel: SplashViewModel,
         updatePopupViewControllerFactory: @escaping () -> UpdatePopupViewController) {
        self.viewModel = viewModel
        self.updatePopupViewControllerFactory = updatePopupViewControllerFactory
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 화면 넘어가는 거 확인용. 나중에 지워야함!
        self.view.backgroundColor = .orange
        
        self.bind()
        self.viewModel.checkUpdateRequired()
    }
}

// MARK: - Methods

extension SplashViewController {
    
    private func bind() {
        self.viewModel.updateRequired
            .asDriver(onErrorJustReturn: true)
            .drive(with: self, onNext: { owner, isRequired in
                if isRequired {
                    owner.showUpdateAlert()
                } else {
                    owner.navigateToHomeTab()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToHomeTab() {
        Observable.just("")
//            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .take(1)
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.navigateToHomeTab()
            })
            .disposed(by: disposeBag)
    }
    
    private func showUpdateAlert() {
        let viewController = self.updatePopupViewControllerFactory()
        viewController.modalPresentationStyle = .overFullScreen
        
        self.present(viewController, animated: true)
    }
}
