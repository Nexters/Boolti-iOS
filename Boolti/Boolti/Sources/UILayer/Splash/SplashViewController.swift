//
//  SplashViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

import RxSwift

final class SplashViewController: UIViewController {

    // MARK: Properties

    private let viewModel: SplashViewModel
    private let disposeBag = DisposeBag()
    
    private let updatePopupViewControllerFactory: () -> UpdatePopupViewController
    
    // MARK: UI Component
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .splashLogo
        return imageView
    }()
    
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
        
        self.configureUI()
        self.configureConstraints()
        self.bind()
        self.viewModel.checkUpdateRequired()
    }
}

// MARK: - Methods

extension SplashViewController {
    
    private func bind() {
        self.viewModel.output.updateRequired
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
            .delay(.seconds(2), scheduler: MainScheduler.instance)
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

// MARK: - UI

extension SplashViewController {
    
    private func configureUI() {
        self.view.addSubview(self.logoImageView)
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(106)
        }
    }
}
