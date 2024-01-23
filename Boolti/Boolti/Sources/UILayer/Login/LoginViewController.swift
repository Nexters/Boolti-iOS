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

    private let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao_login_medium_wide"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
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
        self.view.addSubview(self.kakaoLoginButton)
        self.kakaoLoginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bind() {
        self.kakaoLoginButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.viewModel.loginKakao()
            })
            .disposed(by: self.disposeBag)
    }
}
