//
//  RefundHorizontalStackView.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

final class AccountContentView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey30

        return label
    }()

    let contentTextField: BooltiTextField = {
        let textField = BooltiTextField()

        return textField
    }()

    private let errorCommentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardR(14)
        label.textColor = .error
        label.isHidden = true

        return label
    }()

    var isValidTextTyped: Bool = true {
        didSet {
            self.setErrorCommentUI()
        }
    }

    init(title: String, placeHolder: String, errorComment: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.contentTextField.setPlaceHolderText(placeholder: placeHolder)
        self.errorCommentLabel.text = errorComment
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubviews([
            self.titleLabel,
            self.contentTextField,
            self.errorCommentLabel
        ])

        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(50)
            make.left.equalToSuperview()
        }

        self.contentTextField.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(self.titleLabel.snp.right)
        }

        self.errorCommentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contentTextField)
            make.bottom.equalToSuperview()
        }
    }

    private func setErrorCommentUI() {
        if self.isValidTextTyped {
            self.errorCommentLabel.isHidden = true
            self.contentTextField.layer.borderColor = nil
            self.contentTextField.layer.borderWidth = 0
            self.snp.updateConstraints { make in
                make.height.equalTo(48)
            }
        } else {
            self.errorCommentLabel.isHidden = false
            self.contentTextField.layer.borderColor = UIColor.error.cgColor
            self.contentTextField.layer.borderWidth = 1
            self.snp.updateConstraints { make in
                make.height.equalTo(77)
            }
        }
        self.layoutIfNeeded()
    }
}
