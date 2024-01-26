//
//  LoginViewController.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()

    private let termsAgreementViewControllerFactory: () -> TermsAgreementViewController

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "불티나게 팔리는 티켓, 불티"
        label.font = .headline1
        label.textColor = .grey05
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 불티에서 티켓을 불티나게 팔아보세요!"
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
        // 아래는 navigation controller의 색상으로 갈거므로 삭제될 예정
        self.view.backgroundColor = .black
        self.configureUI()
        self.bindViewModel()
    }

    init(viewModel: LoginViewModel,
         termsAgreementViewControllerFactory: @escaping () -> TermsAgreementViewController
    ) {
        self.viewModel = viewModel
        self.termsAgreementViewControllerFactory = termsAgreementViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
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
            .map { Provider.kakao }
            .drive(with: self) { owner, provider in
                owner.viewModel.input.loginButtonDidTapEvent.onNext(provider)
            }
            .disposed(by: self.disposeBag)

        self.appleLoginButton.rx.tap
            .asDriver()
            .map { Provider.apple }
            .drive(with: self) { owner, provider in
                owner.viewModel.input.loginButtonDidTapEvent.onNext(provider)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {
        self.viewModel.output.didloginFinished
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isFirstSignedUp in
                guard isFirstSignedUp else {
                    self.dismiss(animated: true)
                    return
                }
                self.presentTermsAgreementViewController()
            }
            .disposed(by: self.disposeBag)
    }

    private func presentTermsAgreementViewController() {
        let viewController = self.termsAgreementViewControllerFactory()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}
