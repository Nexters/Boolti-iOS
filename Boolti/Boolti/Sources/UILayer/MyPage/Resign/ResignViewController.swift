//
//  ResignViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/15/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ResignViewController: BooltiViewController {

    private var viewModel: ResignViewModel

    private let disposeBag = DisposeBag()

    private let resignBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85

        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)

        return button
    }()

    private let askingResignLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey15
        label.text = "탈퇴하시겠어요?"
        
        return label
    }()
    
    private let askingResignSubLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.numberOfLines = 0
        label.font = .body1
        label.textColor = .grey30
        label.text = "탈퇴일로부터 30일 이내에 재로그인 시\n계정 삭제를 취소할 수 있습니다.\n30일이 지나면 계정 및 정보가 영구 삭제됩니다."
        label.setAlignCenter()

        return label
    }()

    private let confirmLogoutButton = BooltiButton(title: "탈퇴")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUIComponents()
        self.bindViewModel()
    }

    init(viewModel: ResignViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .black100
        self.resignBackgroundView.layer.cornerRadius = 8

        self.view.addSubviews([
            self.resignBackgroundView,
            self.askingResignLabel,
            self.askingResignSubLabel,
            self.confirmLogoutButton,
            self.closeButton
        ])

        self.resignBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.center.equalToSuperview()
        }

        self.askingResignLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.resignBackgroundView.snp.top).inset(48)
        }
        
        self.askingResignSubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.askingResignLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self.confirmLogoutButton)
        }

        self.confirmLogoutButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.resignBackgroundView).inset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.askingResignSubLabel.snp.bottom).offset(28)
            make.bottom.equalTo(self.resignBackgroundView).inset(20)
        }

        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.resignBackgroundView.snp.top).inset(12)
            make.right.equalTo(self.resignBackgroundView.snp.right).inset(20)
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
            .bind(to: self.viewModel.input.didResignConfirmButtonTap)
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {
        self.viewModel.output.didResignAccount
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
