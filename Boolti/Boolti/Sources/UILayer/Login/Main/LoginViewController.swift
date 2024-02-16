//
//  LoginViewController.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class LoginViewController: BooltiViewController {

    typealias IdentityCode = String

    let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()

    private let termsAgreementControllerFactory: (IdentityCode, OAuthProvider) -> TermsAgreementViewController

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "불티나게 팔리는 티켓, 불티"
        label.font = .headline1
        label.textColor = .grey05
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 티켓을 예매하고 공연을 즐겨보세요!"
        label.font = .body3
        label.textColor = .grey30
        return label
    }()

    private let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(.kakaoLoginButton, for: .normal)

        return button
    }()

    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(.appleLoginButton, for: .normal)

        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.bindViewModel()
    }

    init(viewModel: LoginViewModel,
         termsAgreementControllerFactory: @escaping (IdentityCode, OAuthProvider) -> TermsAgreementViewController
    ) {
        self.viewModel = viewModel
        self.termsAgreementControllerFactory = termsAgreementControllerFactory
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95
        
        self.view.addSubviews([
            self.closeButton,
            self.headerTitleLabel,
            self.subTitleLabel,
            self.kakaoLoginButton,
            self.appleLoginButton
        ])

        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.left.equalToSuperview().inset(20)
        }

        self.subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp.centerY).offset(-40)
        }

        self.headerTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.subTitleLabel.snp.top).offset(-6)
        }

        self.kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.view.snp.centerY)
        }

        self.appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(self.kakaoLoginButton)
            make.height.equalTo(48)
            make.top.equalTo(self.kakaoLoginButton.snp.bottom).offset(12)
        }
    }

    private func bindViewModel() {
        self.bindInput()
        self.bindOutput()
    }

    private func bindInput() {
        self.closeButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.kakaoLoginButton.rx.tap
            .asDriver()
            .map { OAuthProvider.kakao }
            .drive(with: self) { owner, provider in
                owner.viewModel.input.loginButtonDidTapEvent.onNext(provider)
            }
            .disposed(by: self.disposeBag)

        self.appleLoginButton.rx.tap
            .asDriver()
            .map { OAuthProvider.apple }
            .drive(with: self) { owner, provider in
                owner.viewModel.input.loginButtonDidTapEvent.onNext(provider)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {
        self.viewModel.output.didloginFinished
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isSignupRequired in
                if isSignupRequired {
                    owner.presentTermsAgreementViewController()
                } else {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func presentTermsAgreementViewController() {
        guard let identityToken = self.viewModel.identityToken else { return }
        guard let provider = self.viewModel.provider else { return }
        let viewController = self.termsAgreementControllerFactory(identityToken, provider)
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
}
