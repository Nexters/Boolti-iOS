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

    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "불티나게 팔리는 티켓, 불티"
        label.font = .headline1
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 불티에서 티켓을 불티나게 팔아보세요!"
        label.font = .body3
        return label
    }()

    private let kakaoLoginButton = LoginButton(
        image: .kakaoLoginLogo,
        title: "카카오톡으로 시작하기",
        color: UIColor.yellow
    )

    private let appleLoginButton = LoginButton(
        image: .appleLoginLogo,
        title: "Apple로 시작하기",
        color: UIColor.white
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        // 아래는 navigation controller의 색상으로 갈거므로 삭제될 예정
        self.view.backgroundColor = .gray
        self.configureUI()
        self.bind()
    }

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.addSubview(self.headerTitleLabel)
        self.view.addSubview(self.subTitleLabel)
        self.view.addSubview(self.kakaoLoginButton)
        self.view.addSubview(self.appleLoginButton)

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
            make.left.right.equalTo(self.kakaoLoginButton)
            make.height.equalTo(48)
            make.top.equalTo(self.kakaoLoginButton.snp.bottom).offset(12)
        }
    }

    private func bind() {
        
        self.kakaoLoginButton.rx.tap
            .asDriver()
            .map { Provider.kakao }
            .drive(with: self) { owner, provider in
                self.viewModel.login(with: provider)
            }
            .disposed(by: self.disposeBag)


        self.appleLoginButton.rx.tap
            .asDriver()
            .map { Provider.apple }
            .drive(with: self) { owner, provider in
                self.viewModel.login(with: provider)
            }
            .disposed(by: self.disposeBag)
    }
}
