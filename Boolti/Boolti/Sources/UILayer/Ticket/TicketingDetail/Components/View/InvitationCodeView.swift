//
//  InvitationCodeView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/30/24.
//

import UIKit
import RxSwift

final class InvitationCodeView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "초청 코드"
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()
    
    private let codeTextField: BooltiTextField = {
        let button = BooltiTextField()
        button.setPlaceHolderText(placeholder: "예) B123456")
        return button
    }()

    private let useButton: BooltiButton = {
        let button = BooltiButton(title: "사용하기")
        button.backgroundColor = .grey20
        button.setTitleColor(.grey90, for: .normal)
        return button
    }()
    
    private let useInfo: UILabel = {
        let label = UILabel()
        label.text = "사용되었습니다."
        label.textColor = .success
        label.font = .body1
        label.isHidden = true
        return label
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
        self.bindInputs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension InvitationCodeView {
    
    private func bindInputs() {
        self.useButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                
                // TODO: 서버 통신 후 코드 사용 확인 필요
                owner.useInfo.isHidden = false
                owner.useButton.isEnabled = false
                
                owner.snp.updateConstraints { make in
                    make.height.equalTo(163)
                }
            }).disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension InvitationCodeView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.codeTextField, self.useButton, self.useInfo])
        
        self.backgroundColor = .grey90
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(134)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        self.codeTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        self.useButton.snp.makeConstraints { make in
            make.top.equalTo(self.codeTextField)
            make.left.equalTo(self.codeTextField.snp.right).offset(6)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(self.codeTextField)
            make.width.equalTo(96)
        }
        
        self.useInfo.snp.makeConstraints { make in
            make.top.equalTo(self.codeTextField.snp.bottom).offset(12)
            make.left.equalTo(self.codeTextField)
        }
    }
}
