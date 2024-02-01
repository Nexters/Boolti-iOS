//
//  InvitationCodeView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/30/24.
//

import UIKit
import RxSwift
import RxCocoa

enum InvitationCodeState: String {
    case verified = "사용되었습니다."
    case used = "이미 사용된 초청코드입니다."
    case incorrect = "초청 코드가 올바르지 않아요."
    case empty = "초청 코드를 입력해 주세요."
}

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
    
    let codeTextField: BooltiTextField = {
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
    
    private let codeStateLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.isHidden = true
        return label
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension InvitationCodeView {
    
    func didUseButtonTap() -> Signal<Void> {
        return self.useButton.rx.tap.asSignal()
    }
    
    func setCodeState(_ state: InvitationCodeState) {
        self.codeStateLabel.text = state.rawValue
        self.codeStateLabel.isHidden = false
        
        self.snp.updateConstraints { make in
            make.height.equalTo(163)
        }
        
        switch state {
        case .empty, .incorrect, .used:
            self.codeStateLabel.textColor = .error
        case .verified:
            self.codeStateLabel.textColor = .success
            self.codeTextField.isEnabled = false
            self.useButton.isEnabled = false
        }
    }
}

// MARK: - UI

extension InvitationCodeView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.codeTextField, self.useButton, self.codeStateLabel])
        
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
        
        self.codeStateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.codeTextField.snp.bottom).offset(12)
            make.left.equalTo(self.codeTextField)
        }
    }
}
