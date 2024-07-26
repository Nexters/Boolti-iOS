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
    
    // MARK: Properties

    typealias IdentityCode = String

    let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()

    private let termsAgreementControllerFactory: (IdentityCode, OAuthProvider) -> TermsAgreementViewController
    
    // MARK: UI Component

    private let headerTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .headline2
        label.text = "지금 불티에 로그인하고\n 당신의 공연을 시작해보세요"
        label.textAlignment = .center
        label.textColor = .grey05
        label.numberOfLines = 0
        return label
    }()

    private let kakaoLoginButton = SocialServiceButton(title: "카카오톡으로 시작하기", type: .kakao)
    private let appleLoginButton = SocialServiceButton(title: "Apple로 시작하기", type: .apple)

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)

        return button
    }()
    
    private let popupView = BooltiPopupView()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.bindViewModel()
        self.bindUIComponents()
    }

    // MARK: Init
    
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
}

// MARK: - Methods

extension LoginViewController {
    
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
            .throttle(.seconds(2), latest: false)
            .drive(with: self) { owner, provider in
                owner.viewModel.input.loginButtonDidTapEvent.onNext(provider)
            }
            .disposed(by: self.disposeBag)

        self.appleLoginButton.rx.tap
            .asDriver()
            .map { OAuthProvider.apple }
            .throttle(.seconds(2), latest: false)
            .drive(with: self) { owner, provider in
                owner.viewModel.input.loginButtonDidTapEvent.onNext(provider)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {
        self.viewModel.output.didloginFinished
            .asDriver(onErrorJustReturn: SignupConditionEntity(isSignUpRequired: true, removeCancelled: false))
            .drive(with: self) { owner, signupCondition in
                if signupCondition.removeCancelled {
                    owner.popupView.showPopup(with: .accountRemoveCancelled)
                }
                else if signupCondition.isSignUpRequired {
                    owner.presentTermsAgreementViewController()
                }
                else {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindUIComponents() {
        self.popupView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                owner.dismiss(animated: true)
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

// MARK: - UI

extension LoginViewController {

    private func configureUI() {
        self.view.backgroundColor = .grey95
        
        self.view.addSubviews([
            self.closeButton,
            self.headerTitleLabel,
            self.kakaoLoginButton,
            self.appleLoginButton,
            self.popupView
        ])

        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.right.equalToSuperview().inset(20)
        }
        
        self.headerTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.kakaoLoginButton.snp.top).offset(-48)
        }

        self.kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.centerY)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.kakaoLoginButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self.kakaoLoginButton)
            make.height.equalTo(48)
        }

        self.popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
