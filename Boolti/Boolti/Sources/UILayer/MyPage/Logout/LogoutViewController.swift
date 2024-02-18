//
//  LogoutViewController.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import UIKit

import RxSwift
import RxCocoa

final class LogoutViewController: BooltiViewController {

    private var viewModel: LogoutViewModel

    private let disposeBag = DisposeBag()

    private let logoutBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85

        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)

        return button
    }()

    private let askingLogoutLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 로그아웃 하시겠어요?"
        label.font = .subhead2
        label.textColor = .grey15

        return label
    }()

    private let confirmLogoutButton = BooltiButton(title: "로그아웃")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUIComponents()
        self.bindViewModel()
    }

    init(viewModel: LogoutViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .black100
        self.logoutBackgroundView.layer.cornerRadius = 8

        self.view.addSubviews([
            self.logoutBackgroundView,
            self.askingLogoutLabel,
            self.confirmLogoutButton,
            self.closeButton
        ])

        self.logoutBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.center.equalToSuperview()
        }

        self.askingLogoutLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.logoutBackgroundView.snp.top).inset(48)
        }

        self.confirmLogoutButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.logoutBackgroundView).inset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.askingLogoutLabel.snp.bottom).offset(28)
            make.bottom.equalTo(self.logoutBackgroundView.snp.bottom).inset(20)
        }

        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.logoutBackgroundView.snp.top).inset(12)
            make.right.equalTo(self.logoutBackgroundView.snp.right).inset(20)
        }
    }

    private func bindUIComponents() {
        self.closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        self.bindInputs()
        self.bindOutputs()
    }

    private func bindInputs() {
        self.confirmLogoutButton.rx.tap
            .bind(to: self.viewModel.input.didLogoutConfirmButtonTap)
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {
        self.viewModel.output.didLogoutAccount
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
