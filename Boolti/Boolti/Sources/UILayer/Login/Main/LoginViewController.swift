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
        label.text = "불티나게 팔리는 티켓, 불티"
        label.textColor = .grey05
        return label
    }()

    private let subTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.text = "지금 티켓을 예매하고 공연을 즐겨보세요!"
        label.textColor = .grey30
        return label
    }()

    private let kakaoLoginButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "카카오톡으로 시작하기"
        config.attributedTitle?.font = .subhead1
        config.baseForegroundColor = .black100
        config.background.backgroundColor = UIColor.init("#FFE833")
        config.imagePadding = 20

        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 12

        return button
    }()
    
    private let kakaoIconImageView = UIImageView(image: .kakao)

    private let appleLoginButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Apple로 시작하기"
        config.attributedTitle?.font = .subhead1
        config.baseForegroundColor = .black100
        config.background.backgroundColor = UIColor.init("#F6F7FF")
        config.imagePadding = 20

        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 12

        return button
    }()
    
    private let appleIconImageView = UIImageView(image: .apple)

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
            self.subTitleLabel,
            self.kakaoLoginButton,
            self.kakaoIconImageView,
            self.appleLoginButton,
            self.appleIconImageView,
            self.popupView
        ])

        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.left.equalToSuperview().inset(20)
        }
        
        self.headerTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.subTitleLabel.snp.top).offset(-6)
        }

        self.subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp.centerY).offset(-48)
        }

        self.kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.centerY)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.kakaoIconImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(self.kakaoLoginButton)
            make.left.equalTo(self.kakaoLoginButton).offset(20)
        }

        self.appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.kakaoLoginButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self.kakaoLoginButton)
            make.height.equalTo(48)
        }
        
        self.appleIconImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(self.appleLoginButton)
            make.left.equalTo(self.appleLoginButton).offset(20)
        }
        
        self.popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
