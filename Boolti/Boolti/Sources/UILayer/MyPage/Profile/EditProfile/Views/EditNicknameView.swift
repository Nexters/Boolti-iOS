//
//  EditNicknameView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/4/24.
//

import UIKit

import RxSwift
import RxCocoa

final class EditNicknameView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Components
    
    private let nicknameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "닉네임"
        return label
    }()
    
    private let nicknameTextField: BooltiTextField = {
        let textField = BooltiTextField()
        textField.setPlaceHolderText(placeholder: "닉네임을 입력해주세요 (20자 이내)", foregroundColor: .grey70)
        textField.layer.borderColor = UIColor.error.cgColor
        return textField
    }()
    
    private let errorInfoLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .pretendardR(14)
        label.textColor = .error
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.bindTextField()
        self.setOriginData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension EditNicknameView {
    
    private func setOriginData() {
        self.nicknameTextField.text = UserDefaults.userName
        self.nicknameTextField.sendActions(for: .editingChanged)
    }
    
    private func bindTextField() {
        self.nicknameTextField.rx.text
            .asDriver()
            .drive(with: self) { owner, changedText in
                guard let changedText = changedText else { return }
                owner.nicknameTextField.text = changedText
                
                if changedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.nicknameTextField.text = nil
                    owner.nicknameTextField.layer.borderWidth = 1
                    owner.errorInfoLabel.text = "1자 이상 입력해주세요"
                } else {
                    if changedText.count > 20 {
                        owner.nicknameTextField.deleteBackward()
                    }
                    owner.nicknameTextField.layer.borderWidth = 0
                    owner.errorInfoLabel.text = ""
                }
            }
            .disposed(by: self.disposeBag)
        
        self.nicknameTextField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(with: self) { owner, _ in
                guard let text = owner.nicknameTextField.text else { return }
                owner.nicknameTextField.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UI

extension EditNicknameView {
    
    private func configureUI() {
        self.backgroundColor = .grey90
        self.addSubviews([self.nicknameLabel,
                          self.nicknameTextField,
                          self.errorInfoLabel])

        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        self.nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.nicknameLabel.snp.bottom).offset(16)
        }
        
        self.errorInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameTextField.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
        
    }
}
