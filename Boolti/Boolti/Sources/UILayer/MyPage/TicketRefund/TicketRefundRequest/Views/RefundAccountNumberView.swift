//
//  RefundAccountNumberView.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

class RefundAccountNumberView: UIView {

    let accountNumberTextField: BooltiTextField = {
        let textField = BooltiTextField()
        textField.setPlaceHolderText(placeholder: "계좌번호를 입력해 주세요")

        return textField
    }()

    private let errorCommentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardR(14)
        label.textColor = .error
        label.text = "계좌번호 확인 후 다시 입력해 주세요."
        label.isHidden = true

        return label
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubviews([
            self.accountNumberTextField,
            self.errorCommentLabel
        ])

        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        self.accountNumberTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }

        self.errorCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.accountNumberTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
    }

    var isValidTextTyped: Bool = true {
        didSet {
            self.setErrorCommentUI()
        }
    }

    private func setErrorCommentUI() {
        if self.isValidTextTyped {
            self.errorCommentLabel.isHidden = true
            self.accountNumberTextField.layer.borderColor = nil
            self.accountNumberTextField.layer.borderWidth = 0
            self.snp.updateConstraints { make in
                make.height.equalTo(48)
            }
        } else {
            self.errorCommentLabel.isHidden = false
            self.accountNumberTextField.layer.borderColor = UIColor.error.cgColor
            self.accountNumberTextField.layer.borderWidth = 1
            self.snp.updateConstraints { make in
                make.height.equalTo(77)
            }
        }
        self.layoutIfNeeded()
    }




}
