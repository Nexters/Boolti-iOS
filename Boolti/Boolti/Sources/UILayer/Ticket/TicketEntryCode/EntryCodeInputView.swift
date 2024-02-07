//
//  EntryCodeInputView.swift
//  Boolti
//
//  Created by Miro on 2/7/24.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

class EntryCodeInputView: UIView {

    private let disposeBag = DisposeBag()

    var textFieldText = PublishRelay<String>()
    var enableCheckButton = PublishRelay<Bool>()
    var didCheckButtonTap = PublishRelay<Void>()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "입장 코드로 입장 확인"
        label.font = .subhead2
        label.textColor = .grey15

        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "입장 코드는 마이 > QR 스캔 > \n 해당 공연 스캐너에서 확인 가능해요"
        label.numberOfLines = 0
        label.textColor = .grey50
        label.font = .body1
        label.setLineSpacing(lineSpacing: 3)
        label.textAlignment = .center

        return label
    }()

    private let entryCodeInputTextField: BooltiTextField = {
        let textField = BooltiTextField(backgroundColor: .grey80)
        textField.setPlaceHolderText(placeholder: "입장 코드를 입력해 주세요.", foregroundColor: .grey60)

        return textField
    }()

    private let checkButton: BooltiButton = {
        let button = BooltiButton(title: "확인")
        return button
    }()

    private let errorCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "올바른 입장 코드를 입력해 주세요."
        label.font = .body1
        label.textColor = .error
        label.isHidden = true

        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton.withTintColor(.grey50), for: .normal)
        return button
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.configureConstraints()
        self.bindUIComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.backgroundColor = .grey85
        self.layer.cornerRadius = 8
        self.checkButton.isEnabled = false

        self.addSubviews([
            self.closeButton,
            self.titleLabel,
            self.descriptionLabel,
            self.entryCodeInputTextField,
            self.errorCommentLabel,
            self.checkButton
        ])
    }

    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.width.equalTo(311)
            make.height.equalTo(286)
        }

        self.closeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(12)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(48)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
        }

        self.entryCodeInputTextField.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.errorCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.entryCodeInputTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.entryCodeInputTextField)
        }

        self.checkButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.horizontalEdges.equalTo(self.entryCodeInputTextField)
        }
    }

    private func bindUIComponents() {
        self.entryCodeInputTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: self.textFieldText)
            .disposed(by: self.disposeBag)

        self.enableCheckButton
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, enableCheckButton in
                self.checkButton.isEnabled = enableCheckButton
            })
            .disposed(by: self.disposeBag)

        self.checkButton.rx.tap
            .bind(to: self.didCheckButtonTap)
            .disposed(by: self.disposeBag)
    }

    func showErrorComments() {
        self.errorCommentLabel.isHidden = false
        self.entryCodeInputTextField.layer.borderColor = UIColor.error.cgColor
        self.entryCodeInputTextField.layer.borderWidth = 1

        self.snp.updateConstraints { make in
            make.height.equalTo(316)
        }
    }

//    func disableCheckButton() {
//        self.checkButton.isEnabled = false
//    }
//
//    func enableCheckButton() {
//        self.checkButton.isEnabled = true
//    }
}
